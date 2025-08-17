return {
    "seblyng/roslyn.nvim",
    opts = {
        broad_search = true,
        ignore_target = function(sln)
            return string.match(sln, "SmartDok.sln") ~= nil
        end,
    },
    dev = true,
    init = function()
        vim.keymap.set("n", "<leader>ds", function()
            if not vim.g.roslyn_nvim_selected_solution then
                return vim.notify("No solution file found")
            end

            local projects = require("roslyn.sln.api").projects(vim.g.roslyn_nvim_selected_solution)
            local files = vim.iter(projects)
                :map(function(it)
                    return vim.fs.dirname(it)
                end)
                :totable()

            Snacks.picker.files({ dirs = files })
        end)

        local handles = {}

        vim.api.nvim_create_autocmd("User", {
            pattern = "RoslynRestoreProgress",
            callback = function(ev)
                local token = ev.data.params[1]
                local handle = handles[token]
                if handle then
                    handle:report({
                        title = ev.data.params[2].state,
                        message = ev.data.params[2].message,
                    })
                else
                    handles[token] = require("fidget.progress").handle.create({
                        title = ev.data.params[2].state,
                        message = ev.data.params[2].message,
                        lsp_client = {
                            name = "roslyn",
                        },
                    })
                end
            end,
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = "RoslynRestoreResult",
            callback = function(ev)
                local handle = handles[ev.data.token]
                handles[ev.data.token] = nil

                if handle then
                    handle.message = ev.data.err and ev.data.err.message or "Restore completed"
                    handle:finish()
                end
            end,
        })
    end,
}
