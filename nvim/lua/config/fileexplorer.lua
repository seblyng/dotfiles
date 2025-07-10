return {
    "stevearc/oil.nvim",
    init = function()
        vim.keymap.set("n", "-", "<cmd>Oil<CR>")
    end,
    opts = {
        keymaps = {
            ["g?"] = "actions.show_help",
            ["<CR>"] = "actions.select",
            ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
            ["<C-p>"] = "actions.preview",
            ["<C-c>"] = "actions.close",
            ["<C-l>"] = false,
            ["<C-h>"] = false,
            ["-"] = "actions.parent",
            ["_"] = "actions.open_cwd",
            ["`"] = "actions.cd",
            ["gs"] = "actions.change_sort",
            ["gx"] = "actions.open_external",
            ["g."] = "actions.toggle_hidden",
            ["g\\"] = "actions.toggle_trash",
        },
        use_default_keymaps = false,
        view_options = { show_hidden = true },
        preview = {
            border = vim.o.winborder:find(",") and vim.opt.winborder:get() or vim.o.winborder,
        },
    },
}
