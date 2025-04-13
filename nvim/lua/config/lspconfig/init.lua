---------- LSP CONFIG ----------

local function keymap(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = true
    opts.desc = string.format("Lsp: %s", opts.desc)
    vim.keymap.set(mode, l, r, opts)
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("DefaultLspAttach", { clear = true }),
    callback = function()
        keymap("i", "<C-s>", function()
            vim.lsp.buf.signature_help({ border = CUSTOM_BORDER })
        end, { desc = "Signature" })

        keymap("n", "gh", function()
            vim.lsp.buf.hover({ border = CUSTOM_BORDER })
        end, { desc = "Hover" })

        keymap("n", "<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, { desc = "Toggle inlay hints" })
    end,
})

vim.diagnostic.config({
    virtual_text = { spacing = 4, prefix = "●" },
    ---@diagnostic disable-next-line: assign-type-mismatch
    float = { border = CUSTOM_BORDER, source = "if_many" },
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
    "neovim/nvim-lspconfig",
    config = function()
        local blink_ok, blink_cmp = pcall(require, "blink.cmp")
        local capabilities = blink_ok and blink_cmp.get_lsp_capabilities()
            or vim.lsp.protocol.make_client_capabilities()

        vim.lsp.config("*", { capabilities = capabilities })

        -- Servers that are not yet setup with vim.lsp.config
        local legacy = { "eslint", "volar" }
        require("mason-lspconfig").setup_handlers({
            function(server)
                if vim.list_contains(legacy, server) then
                    require("lspconfig")[server].setup({ capabilities = capabilities })
                else
                    vim.lsp.enable(server)
                end
            end,
        })
    end,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
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
        { "b0o/schemastore.nvim" },
        { "williamboman/mason.nvim", config = true, cmd = "Mason", dependencies = { "roslyn.nvim" } },
        { "williamboman/mason-lspconfig.nvim", config = true, cmd = { "LspInstall", "LspUninstall" } },
        { "seblyng/nvim-lsp-extras", opts = { global = { border = CUSTOM_BORDER } }, dev = true },
        { "onsails/lspkind.nvim" },
    },
}
