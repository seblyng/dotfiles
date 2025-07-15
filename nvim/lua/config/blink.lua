return {
    {
        "saghen/blink.cmp",
        dependencies = {
            { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
        },
        version = "1.*",
        opts = {
            keymap = {
                preset = "default",
                ["<CR>"] = { "accept", "fallback" },
                ["<C-d>"] = { "scroll_documentation_down", "fallback" },
                ["<C-u>"] = { "scroll_documentation_up", "fallback" },
            },

            completion = {
                list = { selection = { preselect = false, auto_insert = true } },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 50,
                },
                menu = {
                    max_height = 1000,
                    draw = {
                        columns = { { "kind_icon" }, { "label", gap = 1 } },
                        components = {
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            },
                        },
                    },
                },
            },

            cmdline = { enabled = false },
            snippets = { preset = "luasnip" },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                per_filetype = {
                    sql = { "dadbod", "buffer" },
                },
                providers = {
                    path = { opts = { trailing_slash = false, label_trailing_slash = true } },
                    dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
                },
            },
        },
    },
    {
        "xzbdmw/colorful-menu.nvim",
        lazy = true,
        opts = {
            ls = {
                gopls = { align_type_to_right = false },
                clangd = { align_type_to_right = false },
                ["rust-analyzer"] = { align_type_to_right = false },
                fallback = false,
            },
            max_width = 90,
        },
    },
}
