---@diagnostic disable: missing-fields
vim.pack.add({
    "https://github.com/nvim-neotest/nvim-nio",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/rouge8/neotest-rust",
    "https://github.com/nsidorenco/neotest-vstest",
    {
        src = "https://github.com/nvim-neotest/neotest",
        data = {
            cmd = "Neotest",
            keys = { { "n", "<leader>tt" }, { "n", "<leader>td" } },
            config = function()
                vim.keymap.set("n", "<leader>tt", function()
                    require("neotest").run.run()
                end)

                vim.keymap.set("n", "<leader>td", function()
                    require("neotest").run.run({ strategy = "dap" })
                end)

                vim.api.nvim_create_autocmd("FileType", {
                    pattern = "neotest-output",
                    callback = function()
                        vim.keymap.set("n", "q", "<cmd>q<CR>", { buffer = true, desc = "Close output window" })
                    end,
                })

                ---@type ProgressHandle?
                local handle = nil

                require("neotest").setup({
                    consumers = {
                        seblyng_run = function(client)
                            client.listeners.starting = function()
                                handle = require("fidget.progress").handle.create({
                                    title = "Finding tests",
                                    message = "In progress...",
                                    lsp_client = {
                                        name = "Neotest",
                                    },
                                })
                            end
                            return {}
                        end,
                        seblyng_results = function(client)
                            client.listeners.started = function()
                                if handle then
                                    handle.message = "Completed"
                                    handle:finish()
                                end
                            end
                            return {}
                        end,
                    },
                    adapters = {
                        require("neotest-rust"),
                        require("neotest-vstest")({
                            dap_settings = {
                                type = "coreclr",
                                name = "Attach",
                            },
                        }),
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
        },
    },
})
