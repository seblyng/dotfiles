local function execute(client, bufnr, uri, method)
    local oneofs = {}

    local function choose_next()
        client:request("workspace/executeCommand", {
            command = "hitman.nextMessageTemplateChoice",
            arguments = { { uri = uri, method = method, oneofs = oneofs } },
        }, function(err, choice)
            if err then
                return vim.notify(err.message or tostring(err), vim.log.levels.ERROR, { title = "hitman-lsp" })
            end

            if not choice then
                return client:request("workspace/executeCommand", {
                    command = "hitman.setGrpcMethod",
                    arguments = { { uri = uri, method = method, oneofs = oneofs } },
                }, nil, bufnr)
            end

            vim.ui.select(choice.options or {}, {
                prompt = "gRPC template " .. choice.oneof_label,
                format_item = function(choice_item)
                    return choice_item.field_label
                end,
            }, function(choice_item)
                if not choice_item then
                    return
                end

                table.insert(oneofs, {
                    oneof = choice_item.oneof,
                    field = choice_item.field,
                })
                choose_next()
            end)
        end, bufnr)
    end

    choose_next()
end

---@type vim.lsp.Config
return {
    cmd = { "hitman-lsp" },
    filetypes = { "http", "graphql" },
    root_markers = { "hitman.toml" },
    commands = {
        ["hitman.setGrpcMethod"] = function(data, ctx)
            local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
            local bufnr = assert(ctx.bufnr)
            local args = data.arguments and data.arguments[1] or {}
            local uri = args.uri or vim.uri_from_bufnr(bufnr)
            local method = args.method

            if not method then
                return vim.notify("Missing gRPC method", vim.log.levels.ERROR, { title = "hitman-lsp" })
            end

            execute(client, bufnr, uri, method)
        end,
        ["hitman.selectGrpcMethod"] = function(data, ctx)
            local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
            local bufnr = assert(ctx.bufnr)
            local args = data.arguments and data.arguments[1] or {}
            local uri = args.uri or vim.uri_from_bufnr(bufnr)
            local methods = args.methods or {}

            if vim.tbl_isempty(methods) then
                return vim.notify("No gRPC methods found", vim.log.levels.WARN, { title = "hitman-lsp" })
            end

            vim.ui.select(methods, {
                prompt = "gRPC method",
                format_item = function(item)
                    return item.label
                end,
            }, function(item)
                if not item then
                    return
                end

                execute(client, bufnr, uri, item.method)
            end)
        end,
    },
}
