vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/folke/lazydev.nvim", data = { opts = {} } },
})

require("mason").setup({
    registries = { "github:mason-org/mason-registry", "github:Crashdummyy/mason-registry" },
    ui = { backdrop = 100 },
})

local packages = require("mason-registry").get_installed_packages()
local names = vim.iter(packages):map(function(pack)
    return pack.spec.neovim and pack.spec.neovim.lspconfig
end)

vim.lsp.enable(names:totable())

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("DefaultLspAttach", { clear = true }),
    callback = function()
        vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "Lsp: Hover", buffer = true })

        vim.keymap.set("n", "<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, { desc = "Lsp: Toggle inlay hints", buffer = true })
    end,
})
