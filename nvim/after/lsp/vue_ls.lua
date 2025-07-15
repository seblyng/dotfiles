---@type vim.lsp.Config
return {
    on_init = function(client)
        client.handlers["tsserver/request"] = function(_, result, ctx)
            local ts_client = vim.lsp.get_clients({ bufnr = ctx.bufnr, name = "vtsls" })[1]
            if ts_client == nil then
                vim.notify("Could not find `vtsls`. Required for `vue_ls` to work.", vim.log.levels.ERROR)
                return
            end

            local param = unpack(result)
            local id, command, payload = unpack(param)
            ts_client:exec_cmd({
                title = "vue_request_forward",
                command = "typescript.tsserverRequest",
                arguments = { command, payload },
            }, { bufnr = ctx.bufnr }, function(_, r)
                client:notify("tsserver/response", { { id, r.body } })
            end)
        end
    end,
}
