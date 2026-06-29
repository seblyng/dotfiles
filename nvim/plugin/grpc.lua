local function resolve_path(path)
    path = vim.fn.expand(path)
    if vim.startswith(path, "/") then
        return vim.fs.normalize(path)
    end

    local name = vim.api.nvim_buf_get_name(0)
    local current_buffer_dir = name ~= "" and vim.fs.dirname(name) or vim.uv.cwd()
    return vim.fs.normalize(vim.fs.joinpath(current_buffer_dir, path))
end

local function grpcurl(args)
    local cmd = vim.list_extend({ "grpcurl" }, args)
    local result = vim.system(cmd, { text = true }):wait()
    if result.code ~= 0 then
        local err = vim.trim(result.stderr or "")
        if err == "" then
            err = table.concat(cmd, " ") .. " failed"
        end
        return nil, err
    end
    return result.stdout or ""
end

local function stdout_lines(out)
    return vim.iter(out:gmatch("([^\n]*)\n")):totable()
end

local function parse_request_type(output)
    return output:match("rpc%s+[%w_]+%s*%(%s*%.?([%w_%.]+)%s*%)%s*returns")
end

local function extract_json_block(output)
    local result = {}
    local started = false
    local depth = 0

    for line in output:gmatch("[^\r\n]+") do
        if not started and line:match("^%s*{") then
            started = true
        end

        if started then
            table.insert(result, line)
            local opens = select(2, line:gsub("{", ""))
            local closes = select(2, line:gsub("}", ""))
            depth = depth + opens - closes
            if depth <= 0 then
                break
            end
        end
    end

    if #result == 0 then
        return nil
    end

    return table.concat(result, "\n")
end

local function pick_method(bufnr, protoset, service)
    local output, out_err = grpcurl({ "-protoset", protoset, "list", service })
    if out_err then
        return vim.notify(out_err, vim.log.levels.ERROR, { title = "gRPC" })
    end

    local methods = stdout_lines(output)
    if #methods == 0 then
        return vim.notify("No gRPC methods found for " .. service, vim.log.levels.ERROR, { title = "gRPC" })
    end

    vim.ui.select(methods, { prompt = "gRPC method" }, function(method)
        if not method then
            return
        end

        local description, desc_err = grpcurl({ "-protoset", protoset, "describe", method })
        if desc_err then
            return vim.notify(desc_err, vim.log.levels.ERROR, { title = "gRPC" })
        end

        local request_type = parse_request_type(description)
        if not request_type then
            return vim.notify("Could not find message type for " .. method, vim.log.levels.ERROR, { title = "gRPC" })
        end

        local template, templ_err = grpcurl({ "-protoset", protoset, "-msg-template", "describe", request_type })
        if templ_err then
            return vim.notify(templ_err, vim.log.levels.ERROR, { title = "gRPC" })
        end

        local json = extract_json_block(template)
        if not json then
            return vim.notify("Could not extract JSON for " .. request_type, vim.log.levels.ERROR, { title = "gRPC" })
        end

        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

        local json_lines = vim.split(json, "\n", { plain = true })
        local function find_replacement()
            local last_content_line = 0
            for i, line in ipairs(lines) do
                if line:match("^%s*{") then
                    return json_lines, i - 1
                end

                if line:match("%S") then
                    last_content_line = i
                end
            end
            return vim.list_extend({ "" }, json_lines), last_content_line
        end

        local replacement_lines, replacement_start = find_replacement()
        vim.api.nvim_buf_set_lines(bufnr, replacement_start, -1, false, replacement_lines)
    end)
end

local capabilities = {
    codeActionProvider = true,
    executeCommandProvider = { commands = { "generate_message_template" } },
}
--- @type table<string,function>
local methods = {}

--- @param callback function
function methods.initialize(_, callback)
    return callback(nil, { capabilities = capabilities })
end

--- @param callback function
function methods.shutdown(_, callback)
    return callback(nil, nil)
end

--- @param params { textDocument: { uri: string }, range: vim.pack.lsp.Range, context: vim.pack.lsp.CodeActionContext }
--- @param callback function
methods["textDocument/codeAction"] = function(params, callback)
    local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
    local empty_kind = vim.lsp.protocol.CodeActionKind.Empty
    local only = params.context.only or { empty_kind }
    if not vim.tbl_contains(only, empty_kind) then
        return callback(nil, {})
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local proto = vim.iter(lines):find(function(line)
        return line:match("Protoset:")
    end)

    if not proto then
        return callback(nil, {})
    end

    local proto_path = proto:match("Protoset:%s*(.+)")

    local res = {
        {
            title = "Generate message template",
            command = {
                title = "Generate message template",
                command = "generate_message_template",
                arguments = { bufnr, vim.trim(proto_path) },
            },
        },
    }

    callback(nil, res)
end

-- NOTE: Use `vim.schedule_wrap` to avoid hit-enter after choosing code
-- action via built-in `vim.fn.inputlist()`
--- @param params { command: string, arguments: table }
--- @param callback function
methods["workspace/executeCommand"] = vim.schedule_wrap(function(params, callback)
    --- @type integer, table
    local bufnr, proto = unpack(params.arguments)
    if params.command == "generate_message_template" then
        local protoset = resolve_path(proto)
        if not vim.uv.fs_stat(protoset) then
            return vim.notify("Protoset file does not exist: " .. protoset, vim.log.levels.ERROR, { title = "gRPC" })
        end

        local output, err = grpcurl({ "-protoset", protoset, "list" })
        if err then
            return vim.notify(err, vim.log.levels.ERROR, { title = "gRPC" })
        end

        local services = stdout_lines(output)
        if #services == 0 then
            return vim.notify("No gRPC services found in " .. protoset, vim.log.levels.ERROR, { title = "gRPC" })
        end

        vim.schedule(function()
            vim.ui.select(services, { prompt = "gRPC service" }, function(service)
                if service then
                    pick_method(bufnr, protoset, service)
                end
            end)
        end)
    end
    callback(nil, {})
end)

local dispatchers = {}

-- TODO: Simplify after `vim.lsp.server` is a thing
-- https://github.com/neovim/neovim/pull/24338
local cmd = function(disp)
    -- Store dispatchers to use for showing progress notifications
    dispatchers = disp
    local res, closing, request_id = {}, false, 0

    function res.request(method, params, callback)
        local method_impl = methods[method]
        if method_impl ~= nil then
            method_impl(params, callback)
        end
        request_id = request_id + 1
        return true, request_id
    end

    function res.notify(method, _)
        if method == "exit" then
            dispatchers.on_exit(0, 15)
        end
        return false
    end

    function res.is_closing()
        return closing
    end

    function res.terminate()
        closing = true
    end

    return res
end

local client_id = assert(vim.lsp.start({ cmd = cmd, name = "hitman", root_dir = vim.uv.cwd() }, { attach = false }))

vim.api.nvim_create_autocmd("FileType", {
    pattern = "http",
    callback = function(args)
        vim.lsp.buf_attach_client(args.buf, client_id)
    end,
})
