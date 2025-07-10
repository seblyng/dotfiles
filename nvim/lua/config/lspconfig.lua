---------- LSP CONFIG ----------

local function keymap(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = true
    opts.desc = string.format("Lsp: %s", opts.desc)
    vim.keymap.set(mode, l, r, opts)
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("DefaultLspAttach", { clear = true }),
    callback = function(args)
        keymap("n", "gh", function()
            vim.lsp.buf.hover()
        end, { desc = "Hover" })

        keymap("n", "<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, { desc = "Toggle inlay hints" })

        vim.lsp.document_color.enable(true, args.buf)
    end,
})

vim.diagnostic.config({
    virtual_text = { spacing = 4, prefix = "●" },
    float = { source = "if_many" },
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
        opts = { handlers = { vim.lsp.enable } },
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
                        border = vim.opt.winborder:get(),
                        backdrop = 100,
                    },
                },
                cmd = "Mason",
            },
        },
    },
    { "seblyng/nvim-lsp-extras", opts = {}, dev = true },
    { "b0o/schemastore.nvim", lazy = true },
    { "onsails/lspkind.nvim", lazy = true },
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
