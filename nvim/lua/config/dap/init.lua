return {
    {
        "mfussenegger/nvim-dap",
        keys = { "<leader>d<leader>", "<leader>db" },
        dependencies = {
            "nvim-neotest/nvim-nio",
            {
                "igorlfs/nvim-dap-view",
                opts = {
                    auto_toggle = true,
                    winbar = { default_section = "scopes" },
                    windows = { terminal = { hide = { "coreclr" } } },
                },
            },
        },
        config = function()
            local function keymap(mode, lhs, rhs, opts)
                vim.keymap.set(mode, lhs, function()
                    rhs()
                    vim.fn["repeat#set"](vim.keycode(lhs))
                end, opts)
            end

            vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error", linehl = "", numhl = "" })
            vim.fn.sign_define("DapStopped", { text = "→", texthl = "Error", linehl = "DiffAdd", numhl = "" })

            keymap("n", "<leader>db", require("dap").toggle_breakpoint, { desc = "Dap: Add breakpoint" })
            keymap("n", "<leader>d<leader>", require("dap").continue, { desc = "Dap: Continue debugging" })
            keymap("n", "<leader>dl", require("dap").step_into, { desc = "Dap: Step into" })
            keymap("n", "<leader>dj", require("dap").step_over, { desc = "Dap: Step over" })

            -- Per language config
            require("config.dap.cs").setup()
            require("config.dap.rust").setup()
        end,
    },
}
