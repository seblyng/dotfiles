P = function(...)
    vim.print(...)
end

---@type "blink" | "cmp" | "native"
vim.g.seblj_completion = "blink"

if vim.g.seblj_completion == "native" then
    require("seblyng.completion")
end

COLORSCHEME = "catppuccin"
CUSTOM_BORDER = vim.env.TERM == "xterm-ghostty" and { "", "▄", "", "▌", "", "▀", "", "▐" }
    or { "", "", "", "", "", "", "", "" }

local pmenu_hl = vim.api.nvim_get_hl(0, { name = "Pmenu" }).bg
vim.api.nvim_set_hl(0, "StatusLine", { bg = pmenu_hl })

local windows = vim.uv.os_uname().sysname == "Windows_NT" and vim.env.TERM ~= "xterm-kitty"
if windows then
    CUSTOM_BORDER = "rounded"
    local hl = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = hl })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = hl })
else
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = pmenu_hl })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = pmenu_hl })
end

-- Override vim.keymap.set to have silent as default
local map = vim.keymap.set
---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.set = function(mode, lhs, rhs, opts)
    opts = vim.deepcopy(opts) or {}
    if opts.silent == nil then
        opts.silent = true
    end
    map(mode, lhs, rhs, opts)
end
