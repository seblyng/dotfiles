return {
    "lewis6991/gitsigns.nvim",
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
}
