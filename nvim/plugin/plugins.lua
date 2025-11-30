vim.pack.add({
    { src = "https://github.com/seblyng/nvim-ts-autotag", data = { dev = true } },
    { src = "https://github.com/seblyng/nvim-lsp-extras", data = { dev = true } },
    { src = "https://github.com/seblyng/git-conflict.nvim", data = { dev = true } },
    { src = "https://github.com/github/copilot.vim" },
    { src = "https://github.com/saecki/crates.nvim", data = { opts = {}, event = "BufReadPre Cargo.toml" } },
    { src = "https://github.com/vuki656/package-info.nvim", data = { opts = {}, event = "BufReadPre package.json" } },
    { src = "https://github.com/b0o/schemastore.nvim" },
    { src = "https://github.com/mhinz/vim-startify" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/brianhuster/unnest.nvim" },
    { src = "https://github.com/Bekaboo/dropbar.nvim" },
    { src = "https://github.com/j-hui/fidget.nvim", data = { opts = {} } },
    { src = "https://github.com/chomosuke/term-edit.nvim", data = { opts = { prompt_end = "➜" } } },
    { src = "https://github.com/lambdalisue/vim-suda" },
    { src = "https://github.com/tpope/vim-repeat" },
    { src = "https://github.com/tpope/vim-abolish" },
    { src = "https://github.com/tpope/vim-unimpaired" },
    { src = "https://github.com/tpope/vim-surround" },
    { src = "https://github.com/tpope/vim-dadbod" },
    { src = "https://github.com/kristijanhusak/vim-dadbod-ui" },
    { src = "https://github.com/tpope/vim-sleuth" },
    { src = "https://github.com/tpope/vim-dispatch" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/folke/lazydev.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main", data = { build = ":TSUpdate" } },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
    {
        src = "https://github.com/lewis6991/gitsigns.nvim",
        data = {
            opts = {
                on_attach = function(bufnr)
                    vim.keymap.set("n", "]c", "<cmd>Gitsigns nav_hunk next<CR>", { buffer = bufnr })
                    vim.keymap.set("n", "[c", "<cmd>Gitsigns nav_hunk prev<CR>", { buffer = bufnr })
                    vim.keymap.set("n", "<leader>gm", "<cmd>Gitsigns blame_line<CR>", { buffer = bufnr })
                    vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame<CR>", { buffer = bufnr })
                    vim.keymap.set("n", "<leader>gd", "<cmd>Gitsigns preview_hunk<CR>", { buffer = bufnr })
                    vim.keymap.set("n", "<leader>grh", "<cmd>Gitsigns reset_hunk<CR>", { buffer = bufnr })
                    vim.keymap.set("n", "<leader>grb", "<cmd>Gitsigns reset_buffer<CR>", { buffer = bufnr })
                end,
            },
        },
    },
})

require("mason").setup({
    registries = { "github:mason-org/mason-registry", "github:Crashdummyy/mason-registry" },
    ui = { backdrop = 100 },
})
require("mason-lspconfig").setup()
require("lazydev").setup({
    library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "${3rd}/busted/library" },
        { path = "${3rd}/luassert/library" },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "nvim-test" },
    },
})

vim.keymap.set("n", "s", "<Plug>Ysurround")
vim.keymap.set("n", "S", "<Plug>Yssurround")
vim.keymap.set("x", "s", "<Plug>VSurround")

vim.keymap.set("n", "-", "<cmd>Oil<CR>")
require("oil").setup({
    keymaps = {
        ["<C-l>"] = false,
        ["<C-h>"] = false,
        ["~"] = false,
    },
    view_options = { show_hidden = true },
})

local function map_select(mode, lhs, query)
    vim.keymap.set(mode, lhs, function()
        require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
    end)
end

map_select({ "x", "o" }, "if", "@function.inner")
map_select({ "x", "o" }, "af", "@function.outer")
map_select({ "x", "o" }, "ic", "@class.inner")
map_select({ "x", "o" }, "ac", "@class.outer")

-- stylua: ignore start
vim.keymap.set("n", "<leader>sa", function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner") end)
vim.keymap.set("n", "<leader>sf", function() require("nvim-treesitter-textobjects.swap").swap_next("@function.outer") end)
vim.keymap.set("n", "<leader>sA", function() require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner") end)
vim.keymap.set("n", "<leader>sF", function() require("nvim-treesitter-textobjects.swap").swap_previous("@function.outer") end)
-- stylua: ignore end
