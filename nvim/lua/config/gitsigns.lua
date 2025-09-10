return {
    "lewis6991/gitsigns.nvim",
    opts = {
        on_attach = function(bufnr)
            local gs = require("gitsigns")

            -- stylua: ignore start
            vim.keymap.set("n", "]c", function() gs.nav_hunk("next") end, { buffer = bufnr, desc = "Gitsigns: Go to next diff hunk" })
            vim.keymap.set("n", "[c", function() gs.nav_hunk("prev") end, { buffer = bufnr, desc = "Gitsigns: Go to previous diff hunk" })
            vim.keymap.set("n", "<leader>gm", gs.blame_line, { buffer = bufnr, desc = "Gitsigns: Git blame current line" })
            vim.keymap.set("n", "<leader>gb", gs.blame, { buffer = bufnr, desc = "Gitsigns: Git blame entire file" })
            vim.keymap.set("n", "<leader>gd", gs.preview_hunk, { buffer = bufnr, desc = "Gitsigns: Preview diff hunk" })
            vim.keymap.set("n", "<leader>grh", gs.reset_hunk, { buffer = bufnr, desc = "Gitsigns: Reset diff hunk over cursor" })
            vim.keymap.set("n", "<leader>grb", gs.reset_buffer, { buffer = bufnr, desc = "Gitsigns: Reset diff for entire buffer" })
            -- stylua: ignore end
        end,
    },
}
