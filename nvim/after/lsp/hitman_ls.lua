---@type vim.lsp.Config
return {
    cmd = { "hitman-lsp" },
    filetypes = { "http", "graphql" },
    root_markers = { "hitman.toml" },
    commands = {
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

                client:request("workspace/executeCommand", {
                    command = "hitman.setGrpcMethod",
                    arguments = {
                        {
                            uri = uri,
                            method = item.method,
                        },
                    },
                }, nil, bufnr)
            end)
        end,
    },
}
