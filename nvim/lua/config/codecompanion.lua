return {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionCmd", "CodeCompanionChat", "CodeCompanionActions", "MCPHub" },
    opts = {
        memory = {
            opts = {
                chat = {
                    enabled = true,
                },
            },
        },
        display = {
            diff = {
                provider_opts = {
                    inline = {
                        layout = "buffer",
                    },
                },
            },
        },
        strategies = {
            chat = {
                adapter = "copilot",
                tools = {
                    opts = {
                        auto_submit_errors = true,
                        auto_submit_success = true,
                        default_tools = {
                            "files",
                        },
                    },
                },
            },
            inline = {
                adapter = "copilot",
            },
        },
        extensions = {
            mcphub = {
                callback = "mcphub.extensions.codecompanion",
                opts = {
                    make_tools = true,
                    show_server_tools_in_chat = true,
                    add_mcp_prefix_to_tool_names = false,
                    show_result_in_chat = true,
                    format_tool = nil,
                    make_vars = true,
                    make_slash_commands = true,
                },
            },
        },
    },
    init = function()
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
    end,
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "ravitemer/mcphub.nvim", build = "bundled_build.lua", opts = { use_bundled_binary = true } },
    },
}
