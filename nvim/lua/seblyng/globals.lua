EXTUI_ENABLED = true

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "msgbox", "msgmore" },
    callback = function()
        vim.cmd("set winhighlight=NormalFloat:Normal")
        vim.api.nvim_win_set_config(0, { border = "none" })
    end,
})

if EXTUI_ENABLED then
    require("vim._extui").enable({ msg = { pos = "box" } })
end

P = function(...)
    vim.print(...)
end

---@type "blink" | "native"
vim.g.seblj_completion = "blink"

if vim.g.seblj_completion == "native" then
    require("seblyng.completion")
end

local windows = vim.uv.os_uname().sysname == "Windows_NT"
local ghostty = vim.env.TERM == "xterm-ghostty"
local kitty = vim.env.TERM == "xterm-kitty"

COLORSCHEME = "catppuccin"
CUSTOM_BORDER = windows and not kitty and not ghostty and "rounded"
    or ghostty and { "", "▄", "", "▌", "", "▀", "", "▐" }
    or { "", "", "", "", "", "", "", "" }

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

local signature = vim.lsp.buf.signature_help
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.signature_help = function(config)
    signature(vim.tbl_deep_extend("force", config or {}, { border = CUSTOM_BORDER }))
end

-- I know that these are deprecated, I just don't want the warning all the time
-- Do a very big hack until the plugins I use updates to newer API's
local deprecations = {
    "client.notify",
    "client.is_stopped",
    "vim.lsp.start_client()",
}

local deprecate = vim.deprecate
---@diagnostic disable-next-line: duplicate-set-field
vim.deprecate = function(name, ...)
    if vim.list_contains(deprecations, name) then
        return nil
    end
    return deprecate(name, ...)
end
