---@diagnostic disable: missing-fields
return {
    "nvim-neotest/neotest",
    cmd = { "Neotest" },
    keys = { "<leader>tt", "<leader>td" },
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "rouge8/neotest-rust",
        "nsidorenco/neotest-vstest",
    },
    config = function()
        vim.keymap.set("n", "<leader>tt", function()
            require("neotest").run.run()
        end)

        vim.keymap.set("n", "<leader>td", function()
            require("neotest").run.run({ strategy = "dap" })
        end)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "neotest-output",
            command = "nnoremap q <cmd>q<CR>",
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
}
