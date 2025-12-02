vim.g.startify_enable_special = 0
vim.g.startify_files_number = 6
vim.g.startify_change_to_dir = 0

vim.g.startify_commands = {
    { "Dotfiles", 'lua vim.api.nvim_input("<space>fd")' },
    { "Pack sync", "Pack sync" },
    { "Pack update", "Pack update" },
}

vim.g.startify_lists = {
    { type = "commands", header = { "   Commands" } },
    { type = "files", header = { "   MRU" } },
}

function _G.webDevIcons(path)
    local filename = vim.fn.fnamemodify(path, ":t")
    local extension = vim.fn.fnamemodify(path, ":e")
    return require("nvim-web-devicons").get_icon(filename, extension, { default = true })
end

vim.cmd([[
    function! StartifyEntryFormat() abort
      return 'v:lua.webDevIcons(absolute_path) . " " . entry_path'
    endfunction
]])

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("SebStartifyGroup", { clear = true }),
    pattern = "startify",
    desc = "Hidden cursor for startify buffer",
    callback = function()
        require("seblyng.utils").setup_hidden_cursor()
    end,
})
