---------- TELESCOPE CONFIG ----------

return {
    config = function()
        require("telescope").setup({
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                layout_strategy = "flex",
                layout_config = {
                    flex = {
                        flip_columns = 120,
                    },
                },
                file_ignore_patterns = { "%.git/", "hammerspoon/Spoons/", "fonts/", "icons/" },
                mappings = {
                    i = {
                        ["<C-j>"] = function(prompt_bufnr)
                            require("telescope.actions.layout").cycle_layout_next(prompt_bufnr)
                        end,
                        ["<C-k>"] = function(prompt_bufnr)
                            require("telescope.actions.layout").cycle_layout_prev(prompt_bufnr)
                        end,
                    },
                },
            },
            extensions = {
                fzf = {
                    override_file_sorter = true,
                    override_generic_sorter = true,
                },
                file_browser = {
                    hidden = true,
                },
            },
        })

        require("telescope").load_extension("fzf")
        require("telescope").load_extension("file_browser")
        if pcall(require, "notify") then
            require("telescope").load_extension("notify")
        end
    end,

    init = function()
        local function map(keys, func, desc, opts)
            vim.keymap.set("n", keys, function()
                require("telescope.builtin")[func](opts and opts() or {})
            end, { desc = string.format("Telescope: %s", desc) })
        end

        local use_git_root = true
        vim.keymap.set("n", "<leader>tg", function()
            use_git_root = not use_git_root
            local using = use_git_root and "git root" or "current dir"
            vim.api.nvim_echo({ { string.format("Using %s in telescope", using) } }, false, {})
        end, {
            desc = "Telescope: Toggle root dir between git and cwd",
        })

        local function git_root()
            return require("seblj.utils").get_os_command_output(
                "git",
                { args = { "rev-parse", "--show-toplevel" }, cwd = vim.loop.cwd() }
            )[1]
        end

        local function get_root()
            return use_git_root and git_root() or vim.loop.cwd()
        end

        map("<leader>fo", "oldfiles", "Oldfiles")
        map("<leader>fb", "buffers", "Buffers")
        map("<leader>fk", "keymaps", "Keymaps")
        map("<leader>fa", "autocommands", "Autocommands")
        map("<leader>fh", "help_tags", "Helptags")
        map("<leader>fc", "command_history", "Command history")
        map("<leader>vo", "vim_options", "Vim options")
        map("<leader>fd", "find_files", "Dotfiles", function()
            return { cwd = "~/dotfiles", prompt_title = "Dotfiles", hidden = true }
        end)
        map("<leader>ff", "find_files", "Find files", function()
            ---@diagnostic disable-next-line: param-type-mismatch
            return { prompt_title = vim.fs.basename(vim.loop.cwd()) }
        end)
        map("<leader>fg", "git_files", "Git files", function()
            return { prompt_title = vim.fs.basename(git_root()), recurse_submodules = true }
        end)
        map("<leader>fp", "find_files", "Plugins", function()
            return {
                cwd = vim.fn.stdpath("data") .. "/lazy",
                prompt_title = "Plugins",
                search_dirs = vim.iter.map(function(val)
                    return val.dir
                end, require("lazy").plugins()),
            }
        end)
        map("<leader>fn", "find_files", "Neovim", function()
            return { cwd = "~/Applications/neovim", prompt_title = "Neovim", hidden = true }
        end)

        vim.keymap.set("n", "<leader>fe", "<cmd>Telescope file_browser<CR>", { desc = "Telescope: File Browser" })

        vim.keymap.set("n", "<leader>fs", function()
            vim.ui.input({ prompt = "Grep String: " }, function(input)
                local root = get_root()
                vim.schedule(function()
                    require("telescope.builtin").grep_string({
                        cwd = root,
                        search = input,
                        ---@diagnostic disable-next-line: param-type-mismatch
                        prompt_title = vim.fs.basename(root),
                    })
                end)
            end)
        end, { desc = "Telescope: Grep string" })

        -- Thanks to TJ: https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/telescope/custom/multi_rg.lua
        vim.keymap.set("n", "<leader>fw", function()
            local root = get_root()
            require("telescope.pickers")
                :new({
                    debounce = 100,
                    ---@diagnostic disable-next-line: param-type-mismatch
                    prompt_title = vim.fs.basename(root),
                    previewer = require("telescope.config").values.grep_previewer({}),
                    finder = require("telescope.finders").new_async_job({
                        cwd = root,
                        entry_maker = require("telescope.make_entry").gen_from_vimgrep({ cwd = root }),
                        command_generator = function(prompt)
                            local prompt_split = vim.split(prompt, "  ")
                            local args = { "rg", "-e", prompt_split[1] }
                            if prompt_split[2] then
                                vim.list_extend(args, { "-g", prompt_split[2] })
                            end

                            return vim.tbl_flatten({ args, { "-H", "-n", "-S", "-F", "--column", "-g", "!Spoons/" } })
                        end,
                    }),
                })
                :find()
        end, { desc = "Telescope: Multi grep" })

        local total = {
            "golang",
            "typescript",
            "python",
            "lua",
            "c",
            "rust",
            "xargs",
            "find",
        }

        vim.keymap.set("n", "<leader>fq", function()
            local opts = require("telescope.themes").get_cursor()
            require("telescope.pickers")
                .new(opts, {
                    prompt_title = "Cheat sheet",
                    finder = require("telescope.finders").new_table({ results = total }),
                    sorter = require("telescope.config").values.generic_sorter(opts),
                    attach_mappings = function(_, keymap)
                        keymap({ "i", "n" }, "<CR>", function(bufnr)
                            local content = require("telescope.actions.state").get_selected_entry()
                            require("telescope.actions").close(bufnr)
                            vim.ui.input({ prompt = "Query: " }, function(query)
                                local input = vim.split(query, " ")
                                require("seblj.utils").term({
                                    direction = "tabnew",
                                    focus = true,
                                    cmd = string.format("curl cht.sh/%s/%s", content.value, table.concat(input, "+")),
                                })
                            end)
                        end)
                        return true
                    end,
                })
                :find()
        end, { desc = "curl cht.sh" })
    end,
}
