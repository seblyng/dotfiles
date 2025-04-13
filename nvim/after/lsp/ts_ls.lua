---@type vim.lsp.Config
return {
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = string.format(
                    "%s/node_modules/@vue/language-server",
                    require("mason-registry").get_package("vue-language-server"):get_install_path()
                ),
                languages = { "vue" },
            },
        },
    },
}
