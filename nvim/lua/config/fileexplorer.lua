return {
    "stevearc/oil.nvim",
    init = function()
        vim.keymap.set("n", "-", "<cmd>Oil<CR>")
    end,
    opts = {
        keymaps = {
            ["<C-l>"] = false,
            ["<C-h>"] = false,
            ["~"] = false,
        },
        view_options = { show_hidden = true },
    },
}
