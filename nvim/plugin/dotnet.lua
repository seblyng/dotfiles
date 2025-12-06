vim.pack.add({
    { src = "https://github.com/seblyng/roslyn.nvim", data = { dev = true } },
})

require("roslyn").setup({
    broad_search = true,
    silent = true,
    ignore_target = function(sln)
        return string.match(sln, "SmartDok.sln") ~= nil
    end,
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

local restore_handles = {}

vim.api.nvim_create_autocmd("User", {
    pattern = "RoslynRestoreProgress",
    callback = function(ev)
        local token = ev.data.params[1]
        local handle = restore_handles[token]
        if handle then
            handle:report({
                title = ev.data.params[2].state,
                message = ev.data.params[2].message,
            })
        else
            restore_handles[token] = require("fidget.progress").handle.create({
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
        local handle = restore_handles[ev.data.token]
        restore_handles[ev.data.token] = nil

        if handle then
            handle.message = ev.data.err and ev.data.err.message or "Restore completed"
            handle:finish()
        end
    end,
})

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
