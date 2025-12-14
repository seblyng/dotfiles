vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    {
        src = "https://github.com/olimorris/codecompanion.nvim",
        data = {
            cmd = { "CodeCompanion", "CodeCompanionCmd", "CodeCompanionChat", "CodeCompanionActions" },
            opts = {
                display = {
                    diff = {
                        provider_opts = {
                            inline = {
                                layout = "buffer",
                            },
                        },
                    },
                },
                interactions = {
                    chat = {
                        tools = {
                            opts = {
                                default_tools = {
                                    "files",
                                },
                            },
                        },
                    },
                },
            },
        },
    },
})

local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})
local handles = {}

vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(request)
        local adapter = request.data.adapter
        handles[request.data.id] = require("fidget.progress").handle.create({
            title = (" Requesting assistance (%s)"):format(request.data.strategy),
            message = "In progress...",
            lsp_client = {
                name = ("%s (%s)"):format(adapter.formatted_name, adapter.model),
            },
        })
    end,
})

vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(request)
        local handle = handles[request.data.id]
        handles[request.data.id] = nil

        if handle then
            if request.data.status == "success" then
                handle.message = "Completed"
            elseif request.data.status == "error" then
                handle.message = "Error"
            else
                handle.message = "Cancelled"
            end
            handle:finish()
        end
    end,
})
