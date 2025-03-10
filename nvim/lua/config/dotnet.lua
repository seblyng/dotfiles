return {
    "seblyng/roslyn.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        filewatching = "off",
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
    end,
}
