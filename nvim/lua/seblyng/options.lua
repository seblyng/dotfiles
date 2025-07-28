---------- OPTIONS ----------

vim.cmd.colorscheme("catppuccin")

vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:ver25"
vim.opt.completeopt = { "menuone", "noselect", "fuzzy", "popup" }
vim.opt.completeitemalign = { "kind", "abbr", "menu" }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.clipboard = "unnamedplus"
vim.opt.updatetime = 100
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.foldmethod = "indent"
vim.opt.foldtext = ""
vim.opt.foldlevelstart = 20
vim.opt.showmode = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.undofile = true
vim.opt.cindent = true
vim.opt.cinkeys:remove("0#")
vim.opt.indentkeys:remove("0#")
vim.opt.shortmess:append("c")
vim.opt.fillchars:append("diff:╱")
vim.opt.formatoptions:append("r")
vim.opt.laststatus = 3
vim.opt.wrap = false
vim.opt.title = true
vim.opt.titlestring = "%F"
vim.opt.exrc = true

local windows = vim.uv.os_uname().sysname == "Windows_NT"
local ghostty = vim.env.TERM == "xterm-ghostty"
local kitty = vim.env.TERM == "xterm-kitty"

vim.opt.winborder = windows and not kitty and not ghostty and "rounded"
    or ghostty and { "", "▄", "", "▌", "", "▀", "", "▐" }
    or { "", "", "", "", "", "", "", "" }
