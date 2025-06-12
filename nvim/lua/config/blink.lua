if vim.g.seblj_completion ~= "blink" then
    return {}
end

local is_windows = vim.uv.os_uname().sysname == "Windows_NT"
return {
    {
        "saghen/blink.cmp",
        version = "1.*",
        build = not is_windows and "cargo +nightly build --release" or nil,
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
                    window = { border = CUSTOM_BORDER },
                },
                menu = {
                    max_height = 1000,
                    border = CUSTOM_BORDER,
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
                providers = {
                    path = { opts = { trailing_slash = false, label_trailing_slash = true } },
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
