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
    local res = {
        {
            title = "Generate message template",
            command = {
                title = "Generate message template",
                command = "generate_message_template",
                arguments = { bufnr },
            },
        },
    }

    callback(nil, res)
end

local function get_protopath(lines)
    local proto = vim.iter(lines):find(function(line)
        return line:match("Protoset:")
    end)

    return proto and resolve_path(proto:match("Protoset:%s*(.+)"))
end

local function read_file(path)
    local file = io.open(path, "r")
    if not file then
        return nil
    end

    local content = file:read("*a")
    file:close()

    return content
end

local function read_target(root)
    local target = read_file(vim.fs.joinpath(root, ".hitman-target"))
    if not target then
        return nil
    end

    target = vim.trim(target)
    return target:match("=%s*[\"']?([%w_-]+)[\"']?%s*$") or target:match("^[\"']?([%w_-]+)[\"']?")
end

local function parse_hitman_toml(content)
    local result = {}
    local section = result

    for line in content:gmatch("[^\r\n]+") do
        line = line:gsub("%s+#.*$", "")
        local table_name = line:match("^%s*%[([^%[%]]+)%]%s*$")
        if table_name then
            result[table_name] = result[table_name] or {}
            section = result[table_name]
        elseif line:match("^%s*%[%[([^%[%]]+)%]%]%s*$") then
            section = {}
        else
            local key, value = line:match("^%s*([%w_-]+)%s*=%s*(.-)%s*$")
            if key then
                section[key] = value:match('^"(.*)"$') or value:match("^'(.*)'$") or value
            end
        end
    end

    return result
end

local function decode_toml(path)
    local content = read_file(path)
    if not content then
        return {}
    end

    local ok, result = pcall(parse_hitman_toml, content)
    if not ok then
        vim.notify("Could not parse " .. path .. ": " .. result, vim.log.levels.ERROR, { title = "gRPC" })
        return nil
    end

    return result
end

local function resolve_hitman_value(toml_content, target, key)
    local env = target or "default"
    if type(toml_content[env]) == "table" and toml_content[env][key] then
        return toml_content[env][key]
    end

    return toml_content[key]
end

local function find_proto_service(protoset, api)
    if not api then
        return nil
    end

    local output, err = grpcurl({ "-protoset", protoset, "list" })
    if err then
        return vim.notify(err, vim.log.levels.ERROR, { title = "gRPC" })
    end

    local services = stdout_lines(output)
    if #services == 0 then
        return vim.notify("No gRPC services found in " .. protoset, vim.log.levels.ERROR, { title = "gRPC" })
    end

    local service = vim.iter(services):find(function(s)
        return api == s or api:find(s, 1, true) ~= nil
    end)

    if not service then
        return vim.notify("API not found", vim.log.levels.ERROR, { title = "gRPC" })
    end

    return service
end

local function get_proto_service(protoset, lines)
    local url = vim.iter(lines):find(function(line)
        return line:match("GRPC")
    end)

    if not url then
        return nil
    end

    local method_match = url:match("{{(.-)}}")
    if method_match then
        method_match = vim.trim(method_match)
        local root = vim.fs.root(0, "hitman.toml")
        if not root then
            return vim.notify("Could not find hitman root", vim.log.levels.ERROR, { title = "gRPC" })
        end

        local hitman_path = vim.fs.joinpath(root, "hitman.toml")
        local hitman_local_path = vim.fs.joinpath(root, "hitman.local.toml")

        local decoded_hitman = decode_toml(hitman_path)
        local decoded_hitman_local = decode_toml(hitman_local_path)
        if not decoded_hitman or not decoded_hitman_local then
            return nil
        end

        local toml_content = vim.tbl_deep_extend("force", decoded_hitman, decoded_hitman_local)
        local target = read_target(root)
        local grpc_url = resolve_hitman_value(toml_content, target, method_match)

        return find_proto_service(protoset, grpc_url)
    else
        return find_proto_service(protoset, url)
    end
end

-- NOTE: Use `vim.schedule_wrap` to avoid hit-enter after choosing code
-- action via built-in `vim.fn.inputlist()`
--- @param params { command: string, arguments: table }
--- @param callback function
methods["workspace/executeCommand"] = vim.schedule_wrap(function(params, callback)
    --- @type integer, table
    local bufnr = unpack(params.arguments)
    if params.command == "generate_message_template" then
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local protoset = get_protopath(lines)
        if not protoset or not vim.uv.fs_stat(protoset) then
            return vim.notify(
                "Protoset file does not exist: " .. (protoset or "nil"),
                vim.log.levels.ERROR,
                { title = "gRPC" }
            )
        end

        local service = get_proto_service(protoset, lines)
        if not service then
            return nil
        end

        pick_method(bufnr, protoset, service)
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
