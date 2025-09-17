return {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionCmd", "CodeCompanionChat", "CodeCompanionActions", "MCPHub" },
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

        vim.api.nvim_create_autocmd("User", {
            pattern = "CodeCompanionChatCreated",
            callback = function(event)
                local chat = require("codecompanion").buf_get_chat(event.data.bufnr)
                if not chat then
                    return
                end

                local rule_files = {
                    ".github/copilot-instructions.md",
                }

                local slash_commands = require("codecompanion.strategies.chat.slash_commands")
                local start_path = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
                local found_files = {}

                local function try_add_context(dir)
                    for _, rule in ipairs(rule_files) do
                        local path = vim.fs.joinpath(dir, rule)
                        if vim.uv.fs_stat(path) and not vim.list_contains(found_files, path) then
                            table.insert(found_files, path)
                            slash_commands.context(chat, "file", { path = path })
                        end
                    end
                end

                try_add_context(start_path)
                for dir in vim.fs.parents(start_path) do
                    try_add_context(dir)
                end
            end,
        })
    end,
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "ravitemer/mcphub.nvim", build = "npm install -g mcp-hub@latest", opts = {} },
    },
}
