if vim.g.seblj_completion ~= "cmp" then
    return {}
end

return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        { "onsails/lspkind.nvim" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "saadparwaiz1/cmp_luasnip" },
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
        local cmp = require("cmp")
        return {
            sources = {
                { name = "luasnip" },
                { name = "nvim_lsp" },
                { name = "buffer", option = { keyword_pattern = [[\k\+]] } },
                { name = "path" },
                { name = "crates" },
            },

            confirmation = {
                -- This seems annoying, so disable it for now for all language servers
                get_commit_characters = function(_)
                    return {}
                end,
            },

            mapping = cmp.mapping.preset.insert({
                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-Space>"] = cmp.mapping.complete({}),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
            }),

            preselect = cmp.PreselectMode.None,

            window = {
                documentation = {
                    border = CUSTOM_BORDER,
                    winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,Search:None",
                },
                completion = {
                    border = CUSTOM_BORDER,
                    winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual",
                },
            },

            formatting = {
                fields = { "kind", "abbr" },
                format = (function()
                    return function(entry, vim_item)
                        local highlights_info = require("colorful-menu").cmp_highlights(entry)

                        if highlights_info then
                            vim_item.abbr_hl_group = highlights_info.highlights
                            vim_item.abbr = highlights_info.text
                        end
                        return require("lspkind").cmp_format({ mode = "symbol" })(entry, vim_item)
                    end
                end)(),
            },
        }
    end,
}
