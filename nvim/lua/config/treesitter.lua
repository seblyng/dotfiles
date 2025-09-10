vim.treesitter.language.register("bash", "zsh")

return {
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", branch = "main" },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        config = function()
            local function map_select(mode, lhs, query)
                vim.keymap.set(mode, lhs, function()
                    require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
                end)
            end

            map_select({ "x", "o" }, "if", "@function.inner")
            map_select({ "x", "o" }, "af", "@function.outer")
            map_select({ "x", "o" }, "ic", "@class.inner")
            map_select({ "x", "o" }, "ac", "@class.outer")

            -- Swap
            local swap = require("nvim-treesitter-textobjects.swap")

            ---@param swap_fn fun(query_string_regex: string)
            ---@param query_string_regex string
            local function wrap_swap(swap_fn, query_string_regex)
                return function()
                    swap_fn(query_string_regex)
                end
            end

            vim.keymap.set("n", "<leader>sa", wrap_swap(swap.swap_next, "@parameter.inner"))
            vim.keymap.set("n", "<leader>sf", wrap_swap(swap.swap_next, "@function.outer"))

            vim.keymap.set("n", "<leader>sA", wrap_swap(swap.swap_previous, "@parameter.inner"))
            vim.keymap.set("n", "<leader>sF", wrap_swap(swap.swap_previous, "@function.outer"))
        end,
    },
}
