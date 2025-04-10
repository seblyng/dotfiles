return {
    {
        "mfussenegger/nvim-dap",
        keys = { "<leader>d<leader>", "<leader>db" },
        dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            ---@diagnostic disable-next-line: missing-fields
            dapui.setup({
                mappings = {
                    edit = "i",
                    remove = "dd",
                },
            })

            local function keymap(mode, lhs, rhs, opts)
                opts.desc = string.format("Dap: %s", opts.desc)
                vim.keymap.set(mode, lhs, function()
                    rhs()
                    vim.fn["repeat#set"](vim.keycode(lhs))
                end, opts)
            end

            vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error", linehl = "", numhl = "" })
            vim.fn.sign_define("DapStopped", { text = "→", texthl = "Error", linehl = "DiffAdd", numhl = "" })

            keymap("n", "<leader>db", dap.toggle_breakpoint, { desc = "Add breakpoint" })
            keymap("n", "<leader>d<leader>", dap.continue, { desc = "Continue debugging" })
            keymap("n", "<leader>dl", dap.step_into, { desc = "Step into" })
            keymap("n", "<leader>dj", dap.step_over, { desc = "Step over" })

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            -- Per language config
            require("config.dap.cs").setup()
            require("config.dap.rust").setup()
        end,
    },
}

-- TODO: Look into maybe replacing `nvim-dap-ui` with something a lot more minimal
-- local widgets = require('dap.ui.widgets')
--
-- -- set scopes as right pane
-- local scopes = widgets.sidebar(widgets.scopes, {}, 'vsplit')
--
-- -- set frames as bottom pane
-- local frames = widgets.sidebar(widgets.frames, {height = 10}, 'belowright split')
--
-- vim.keymap.set('n', '<leader>dj', dap.continue)
-- vim.keymap.set('n', '<leader>dm', dap.step_over)
-- vim.keymap.set('n', '<leader>di', dap.step_into)
-- vim.keymap.set('n', '<leader>dk', dap.toggle_breakpoint)
-- vim.keymap.set('n', '<leader>dn', dap.clear_breakpoints)
-- vim.keymap.set('n', '<leader>dt', dap.terminate)
--
-- local repl = require('dap.repl')
--
-- vim.keymap.set(
--   'n', '<leader>da',
--   function()
--     return repl.toggle({}, 'belowright split')
--   end
-- )
--
-- vim.keymap.set('n', '<leader>ds', scopes.toggle)
-- vim.keymap.set('n', '<leader>du', frames.toggle)
-- vim.keymap.set('n', '<leader>dh', widgets.hover)
