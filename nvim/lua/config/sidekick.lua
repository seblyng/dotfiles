if true then
    return {}
end
return {
    "folke/sidekick.nvim",
    opts = {},
    init = function()
        vim.keymap.set("n", "<Tab>", function()
            if not require("sidekick").nes_jump_or_apply() then
                return "<Tab>"
            end
        end, { expr = true })
    end,
}
