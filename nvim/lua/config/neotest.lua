---@diagnostic disable: missing-fields
return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        { "rouge8/neotest-rust", dev = true },
    },
    config = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "neotest-output",
            command = "nnoremap q <cmd>q<CR>",
        })

        require("neotest").setup({
            adapters = {
                require("neotest-rust"),
            },
            floating = {
                ---@diagnostic disable-next-line: assign-type-mismatch
                border = CUSTOM_BORDER,
            },
            icons = {
                running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
            },
            summary = {
                mappings = {
                    expand = { "<CR>", "<2-LeftMouse>" },
                    expand_all = "ge",
                    jumpto = "gd",
                    next_failed = "]d",
                    prev_failed = "[d",
                    output = "gh",
                    run = "r",
                    stop = "u",
                    watch = "gw",
                },
            },
        })
    end,
}
