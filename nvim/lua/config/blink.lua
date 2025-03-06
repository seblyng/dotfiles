if vim.g.seblj_completion ~= "blink" then
    return {}
end

return {
    "saghen/blink.cmp",
    event = "InsertEnter",
    build = "cargo +nightly build --release",
    dependencies = {
        {
            "xzbdmw/colorful-menu.nvim",
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
    },
    opts = function()
        return {
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
            sources = { default = { "lsp", "path", "snippets", "buffer" } },
        }
    end,
}
