vim.pack.add({
    { src = "https://github.com/seblyng/nvim-ts-autotag", data = { dev = true } },
    { src = "https://github.com/seblyng/nvim-lsp-extras", data = { dev = true } },
    { src = "https://github.com/seblyng/git-conflict.nvim", data = { dev = true } },
    { src = "https://github.com/seblyng/nvim-startuptime", data = { dev = true } },
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
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", data = { build = ":TSUpdate" } },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("gitsigns").setup({
    on_attach = function(bufnr)
        vim.keymap.set("n", "]c", "<cmd>Gitsigns nav_hunk next<CR>", { buffer = bufnr })
        vim.keymap.set("n", "[c", "<cmd>Gitsigns nav_hunk prev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>gm", "<cmd>Gitsigns blame_line<CR>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame<CR>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>gd", "<cmd>Gitsigns preview_hunk<CR>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>grh", "<cmd>Gitsigns reset_hunk<CR>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>grb", "<cmd>Gitsigns reset_buffer<CR>", { buffer = bufnr })
    end,
})

vim.keymap.set("n", "s", "<Plug>Ysurround")
vim.keymap.set("n", "S", "<Plug>Yssurround")
vim.keymap.set("x", "s", "<Plug>VSurround")

vim.keymap.set("n", "-", "<cmd>Oil<CR>")
require("oil").setup({
    view_options = { show_hidden = true },
    keymaps = {
        ["<C-l>"] = false,
        ["<C-h>"] = false,
    },
})

-- stylua: ignore start
vim.keymap.set({ "x", "o" }, "if", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.inner") end)
vim.keymap.set({ "x", "o" }, "af", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer") end)
vim.keymap.set({ "x", "o" }, "ic", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.inner") end)
vim.keymap.set({ "x", "o" }, "ac", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.outer") end)

vim.keymap.set("n", "<leader>sa", function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner") end)
vim.keymap.set("n", "<leader>sf", function() require("nvim-treesitter-textobjects.swap").swap_next("@function.outer") end)
vim.keymap.set("n", "<leader>sA", function() require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner") end)
vim.keymap.set("n", "<leader>sF", function() require("nvim-treesitter-textobjects.swap").swap_previous("@function.outer") end)
-- stylua: ignore end
