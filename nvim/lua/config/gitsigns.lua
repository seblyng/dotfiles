return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufWritePre" },
    opts = {
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local function map(m, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                opts.desc = string.format("Gitsigns: %s", opts.desc)
                vim.keymap.set(m, l, r, opts)
            end

            -- stylua: ignore start
            map("n", "]c", function() gs.nav_hunk("next") end, { desc = "Go to next diff hunk" })
            map("n", "[c", function() gs.nav_hunk("prev") end, { desc = "Go to previous diff hunk" })
            -- stylua: ignore end

            map("n", "<leader>gm", gs.blame_line, { desc = "Git blame current line" })
            map("n", "<leader>gb", gs.blame, { desc = "Git blame entire file" })
            map("n", "<leader>gd", gs.preview_hunk, { desc = "Preview diff hunk" })
            map("n", "<leader>grh", gs.reset_hunk, { desc = "Reset diff hunk over cursor" })
            map("n", "<leader>grb", gs.reset_buffer, { desc = "Reset diff for entire buffer" })
        end,
    },
}
