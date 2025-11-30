vim.pack.add({
    "https://github.com/folke/snacks.nvim",
})

local idx = 1
local preferred = {
    "default",
    "vertical",
}

vim.api.nvim_create_autocmd("User", {
    pattern = "OilActionsPost",
    callback = function(event)
        if event.data.actions.type == "move" then
            Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
    end,
})

require("snacks").setup({
    picker = {
        main = { file = false, current = true },
        ui_select = false,
        win = {
            input = {
                keys = {
                    ["<c-x>"] = { "edit_split", mode = { "i", "n" } },
                    ["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },

                    ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                    ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
                    ["<c-.>"] = { "toggle_hidden", mode = { "i", "n" } },
                    ["<c-i>"] = { "toggle_ignored", mode = { "i", "n" } },

                    ["<c-m>"] = { "toggle_maximize", mode = { "i", "n" } },
                    ["<c-j>"] = { "cycle_layout_next", mode = { "i", "n" } },
                    ["<c-k>"] = { "cycle_layout_prev", mode = { "i", "n" } },
                },
            },
        },
        layouts = {
            default = {
                layout = {
                    backdrop = false,
                    box = "horizontal",
                    width = 0.8,
                    min_width = 120,
                    height = 0.8,
                    {
                        box = "vertical",
                        border = "rounded",
                        title = "{title} {live} {flags}",
                        { win = "input", height = 1, border = "bottom" },
                        { win = "list", border = "none" },
                    },
                    { win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
                },
            },
            vertical = { layout = { border = "rounded" } },
        },
        actions = {
            cycle_layout_next = function(picker)
                idx = idx % #preferred + 1
                picker:set_layout(preferred[idx])
            end,
            cycle_layout_prev = function(picker)
                idx = (idx - 2) % #preferred + 1
                picker:set_layout(preferred[idx])
            end,
        },
    },
})

-- stylua: ignore start
vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Picker: Recent" })
vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Picker: Buffers" })
vim.keymap.set("n", "<leader>fk", function() Snacks.picker.keymaps() end, { desc = "Picker: Keymaps" })
vim.keymap.set("n", "<leader>fa", function() Snacks.picker.autocmds() end, { desc = "Picker: Autocmds" })
vim.keymap.set("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Picker: Help" })
vim.keymap.set("n", "<leader>fc", function() Snacks.picker.command_history() end, { desc = "Picker: Command history" })
vim.keymap.set("n", "<leader>fn", function() Snacks.picker.files({ cwd = "~/Applications/neovim", title = "Neovim" }) end, { desc = "Picker: Neovim" })
vim.keymap.set("n", "<leader>fw", function() Snacks.picker.grep({
    title = vim.fs.basename(vim.g.use_git_root and vim.fs.root(0, ".git") or vim.uv.cwd()),
    cwd = vim.g.use_git_root and vim.fs.root(0, ".git") or vim.uv.cwd(),
}) end, { desc = "Picker: Grep" })

vim.keymap.set("n", "<leader>nt", function() Snacks.picker.explorer() end, { desc = "Picker: Explorer" })
vim.keymap.set("n", "<leader>fg", function() Snacks.picker.git_files({ title = vim.fs.basename(vim.fs.root(0, ".git")) }) end, { desc = "Picker: Git Files" })
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files({ title = vim.fs.basename(vim.uv.cwd()) }) end, { desc = "Picker: Files" })
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Picker: Lsp definition" })
vim.keymap.set("n", "grr", function() Snacks.picker.lsp_references() end, { desc = "Picker: Lsp references" })
vim.keymap.set("n", "<leader>dw", function() Snacks.picker.diagnostics() end, { desc = "Picker: Diagnostics" })

vim.keymap.set("n", "<leader>fd", function()
    local exclude = { "hammerspoon[/\\]Spoons", "fonts[\\/]*", "icons[/\\]*" }
    Snacks.picker.files({ cwd = "~/dotfiles", exclude = exclude, title = "Dotfiles", hidden = true })
end, { desc = "Picker: Dotfiles" })

vim.keymap.set("n", "<leader>fp", function()
    local plugins = vim.iter(vim.pack.get()):map(function(it) return it.path end):totable()
    Snacks.picker.files({ title = "Plugins", dirs = plugins })
end, { desc = "Picker: Plugins" })
-- stylua: ignore end
