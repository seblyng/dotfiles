---------- LSP CONFIG ----------

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("DefaultLspAttach", { clear = true }),
    callback = function()
        vim.keymap.set("n", "gh", function()
            vim.lsp.buf.hover()
        end, { desc = "Lsp: Hover", buffer = true })

        vim.keymap.set("n", "<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, { desc = "Lsp: Toggle inlay hints", buffer = true })

        -- vim.lsp.inline_completion.enable(true)
        --
        -- vim.keymap.set("i", "<A-]>", function()
        --     vim.lsp.inline_completion.select({ count = 1 })
        -- end)
        --
        -- vim.keymap.set("i", "<A-[>", function()
        --     vim.lsp.inline_completion.select({ count = -1 })
        -- end)
        --
        -- vim.keymap.set("i", "<Tab>", function()
        --     if not vim.lsp.inline_completion.get() then
        --         return "<Tab>"
        --     end
        -- end, { expr = true })
    end,
})

vim.diagnostic.config({
    virtual_text = { spacing = 4, prefix = "●" },
    float = { source = "if_many" },
    status = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignHint",
        },
    },
})

return {
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "neovim/nvim-lspconfig" },
            {
                "mason-org/mason.nvim",
                opts = {
                    registries = {
                        "github:mason-org/mason-registry",
                        "github:Crashdummyy/mason-registry",
                    },
                    ui = {
                        backdrop = 100,
                    },
                },
                cmd = "Mason",
            },
        },
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "${3rd}/busted/library" },
                { path = "${3rd}/luassert/library" },
                { path = "snacks.nvim", words = { "Snacks" } },
                { path = "nvim-test" },
            },
        },
    },
}
