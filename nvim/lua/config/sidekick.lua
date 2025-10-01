return {
    "folke/sidekick.nvim",
    opts = {},
    init = function()
        vim.keymap.set("n", "<Tab>", function()
            if not require("sidekick").nes_jump_or_apply() then
                return "<Tab>"
            end
        end, { expr = true })

        vim.keymap.set({ "n", "v" }, "<C-.>", function()
            require("sidekick.cli").focus()
        end)

        vim.keymap.set({ "n", "v" }, "<leader>aa", function()
            require("sidekick.cli").toggle({ focus = true })
        end)

        vim.keymap.set({ "n", "v" }, "<leader>ap", function()
            require("sidekick.cli").select_prompt()
        end)
    end,
}
