vim.pack.add({
    { src = "https://github.com/kristijanhusak/vim-dadbod-completion" },
    { src = "https://github.com/xzbdmw/colorful-menu.nvim" },
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
})

require("colorful-menu").setup({
    ls = {
        gopls = { align_type_to_right = false },
        clangd = { align_type_to_right = false },
        ["rust-analyzer"] = { align_type_to_right = false },
        fallback = false,
    },
    max_width = 90,
})

require("blink-cmp").setup({
    keymap = {
        preset = "default",
        ["<CR>"] = {
            function(cmp)
                local list = require("blink.cmp.completion.list")
                local item = list.get_selected_item()
                if not cmp.is_visible() or item == nil then
                    return
                end

                vim.schedule(function()
                    list.undo_preview()
                    require("blink.cmp.completion.accept")(list.context, item, function()
                        list.accept_emitter:emit({ item = item, context = list.context })
                    end)
                end)

                return vim.api.nvim_replace_termcodes("<ESC>a", true, false, true)
            end,
            "fallback",
        },
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
})
