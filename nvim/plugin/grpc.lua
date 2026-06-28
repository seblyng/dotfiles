local function resolve_path(path)
    path = vim.fn.expand(path)
    if vim.startswith(path, "/") then
        return vim.fs.normalize(path)
    end

    local name = vim.api.nvim_buf_get_name(0)
    local current_buffer_dir = name ~= "" and vim.fs.dirname(name) or vim.uv.cwd()
    return vim.fs.normalize(vim.fs.joinpath(current_buffer_dir, path))
end

local function system(args)
    local result = vim.system(args, { text = true }):wait()
    if result.code ~= 0 then
        local err = vim.trim(result.stderr or "")
        if err == "" then
            err = table.concat(args, " ") .. " failed"
        end
        return nil, err
    end
    return result.stdout or ""
end

local function grpcurl(args)
    return system(vim.list_extend({ "grpcurl" }, args))
end

local function lines(out)
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

local function pick_method(protoset, service)
    local output, out_err = grpcurl({ "-protoset", protoset, "list", service })
    if out_err then
        return vim.notify(out_err, vim.log.levels.ERROR, { title = "gRPC" })
    end

    local methods = lines(output)
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

        vim.fn.setreg("+", json)
        vim.notify("Copied to clipboard", vim.log.levels.INFO, { title = "gRPC" })
    end)
end

local function grpc_template()
    vim.ui.input({ prompt = "Protoset: " }, function(input)
        if not input or vim.trim(input) == "" then
            return
        end

        local protoset = resolve_path(vim.trim(input))
        if not vim.uv.fs_stat(protoset) then
            return vim.notify("Protoset file does not exist: " .. protoset, vim.log.levels.ERROR, { title = "gRPC" })
        end

        local output, err = grpcurl({ "-protoset", protoset, "list" })
        if err then
            return vim.notify(err, vim.log.levels.ERROR, { title = "gRPC" })
        end

        local services = lines(output)
        if #services == 0 then
            return vim.notify("No gRPC services found in " .. protoset, vim.log.levels.ERROR, { title = "gRPC" })
        end

        vim.ui.select(services, { prompt = "gRPC service" }, function(service)
            if service then
                pick_method(protoset, service)
            end
        end)
    end)
end

vim.api.nvim_create_user_command("GrpcTemplate", grpc_template, {})
vim.keymap.set("n", "<leader>gt", grpc_template, { desc = "gRPC: Insert message template" })
