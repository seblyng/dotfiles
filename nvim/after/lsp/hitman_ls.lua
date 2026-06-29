local function execute_command(client, bufnr, command, arguments, callback)
    client:request("workspace/executeCommand", {
        command = command,
        arguments = arguments,
    }, function(err, result)
        if err then
            vim.notify(err.message, vim.log.levels.ERROR, { title = "hitman-lsp" })
            return
        end

        callback(result)
    end, bufnr)
end

---@type vim.lsp.Config
return {
    cmd = { "hitman-lsp" },
    filetypes = { "http" },
    root_markers = { "hitman.toml" },
    commands = {
        ["hitman.selectGrpcMethod"] = function(cmd, ctx)
            local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
            local bufnr = assert(ctx.bufnr)
            local args = cmd.arguments and cmd.arguments[1] or {}
            local uri = args.uri or vim.uri_from_bufnr(bufnr)

            execute_command(client, bufnr, "hitman.listGrpcMethods", { { uri = uri } }, function(methods)
                if not methods or vim.tbl_isempty(methods) then
                    vim.notify("No gRPC methods found", vim.log.levels.WARN, { title = "hitman-lsp" })
                    return
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

                    execute_command(client, bufnr, "hitman.setGrpcMethod", {
                        {
                            uri = uri,
                            method = item.method,
                        },
                    })
                end)
            end)
        end,
    },
}
