return {
    "folke/snacks.nvim",
    priority = 1000,
    config = function()
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

        ---@diagnostic disable-next-line: missing-fields
        require("snacks").setup({
            -- bigfile = { enabled = true },
            picker = {
                main = { file = false },
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
                    default = { layout = { backdrop = false } },
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
    end,
    -- stylua: ignore
    keys = {
        { "<leader>fr", function() Snacks.picker.recent() end, { desc = "Picker: Recent" } },
        { "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Picker: Buffers" } },
        { "<leader>fk", function() Snacks.picker.keymaps() end, { desc = "Picker: Keymaps" } },
        { "<leader>fa", function() Snacks.picker.autocmds() end, { desc = "Picker: Autocmds" } },
        { "<leader>fh", function() Snacks.picker.help() end, { desc = "Picker: Help" } },
        { "<leader>fc", function() Snacks.picker.command_history() end, { desc = "Picker: Command history" } },
        { "<leader>fn", function() Snacks.picker.files({ cwd = "~/Applications/neovim", title = "Neovim" }) end, { desc = "Picker: Neovim" } },
        { "<leader>fw", function() Snacks.picker.grep({
            title = vim.fs.basename(vim.g.use_git_root and vim.fs.root(0, ".git") or vim.uv.cwd()),
            cwd = vim.g.use_git_root and vim.fs.root(0, ".git") or vim.uv.cwd(),
        }) end, { desc = "Picker: Grep"} },

        -- TODO(seb): J and K doesn't work exactly as expected all the times for me
        { "<leader>nt", function() Snacks.picker.explorer() end, { desc = "Picker: Explorer"} },

        { "<leader>fg", function() Snacks.picker.git_files({ title = vim.fs.basename(vim.fs.root(0, ".git")) }) end, { desc = "Picker: Git Files"} },
        { "<leader>ff", function() Snacks.picker.files({ title = vim.fs.basename(vim.uv.cwd()) }) end, { desc = "Picker: Files"} },

        -- LSP
        { "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Picker: Lsp definition" } },
        { "grr", function() Snacks.picker.lsp_references() end, { desc = "Picker: Lsp references" } },
        { "<leader>dw", function() Snacks.picker.diagnostics() end, { desc = "Picker: Diagnostics" } },

        { "<leader>fd", function()
            local exclude = { "hammerspoon[/\\]Spoons", "fonts[\\/]*", "icons[/\\]*" }
            Snacks.picker.files({ cwd = "~/dotfiles", exclude = exclude, title = "Dotfiles", hidden = true })
        end, { desc = "Picker: Dotfiles" } },

        { "<leader>fp", function() Snacks.picker.files({
           title = "Plugins",
           dirs = vim.iter(require("lazy").plugins())
               :map(function(val)
                   return val.dir
               end)
               :totable()
        }) end, { desc = "Picker: Plugins"} },

    },
    lazy = false,
}
