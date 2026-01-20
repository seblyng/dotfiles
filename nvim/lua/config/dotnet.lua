vim.pack.add({
    { src = "https://github.com/seblyng/roslyn.nvim", data = { dev = true } },
})

require("roslyn").setup({
    broad_search = true,
    silent = true,
})

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

local init_handles = {}
vim.api.nvim_create_autocmd("User", {
    pattern = "RoslynOnInit",
    callback = function(ev)
        init_handles[ev.data.client_id] = require("fidget.progress").handle.create({
            title = "Initializing Roslyn",
            message = ev.data.type == "solution" and string.format("Initializing Roslyn for %s", ev.data.target)
                or "Initializing Roslyn for project",
            lsp_client = {
                name = "roslyn",
            },
        })
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "RoslynInitialized",
    callback = function(ev)
        local handle = init_handles[ev.data.client_id]
        init_handles[ev.data.client_id] = nil

        if handle then
            handle.message = "Roslyn initialized"
            handle:finish()
        end
    end,
})
