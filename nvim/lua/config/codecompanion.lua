return {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionCmd", "CodeCompanionChat", "CodeCompanionActions" },
    opts = {
        adapters = {
            copilot = function()
                return require("codecompanion.adapters").extend("copilot", {
                    schema = { model = { default = "gpt-4.1" } },
                })
            end,
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
        {
            "echasnovski/mini.diff",
            config = function()
                local diff = require("mini.diff")
                diff.setup({ source = diff.gen_source.none() })
            end,
        },
        {
            "HakonHarnes/img-clip.nvim",
            opts = {
                filetypes = {
                    codecompanion = {
                        prompt_for_file_name = false,
                        template = "[Image]($FILE_PATH)",
                        use_absolute_path = true,
                    },
                },
            },
        },
    },
}
