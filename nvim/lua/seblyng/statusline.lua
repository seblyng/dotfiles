local M = {}

local mode_alias = {
    ["n"] = "NORMAL",
    ["no"] = "OP",
    ["nov"] = "OP",
    ["noV"] = "OP",
    ["no"] = "OP",
    ["niI"] = "NORMAL",
    ["niR"] = "NORMAL",
    ["niV"] = "NORMAL",
    ["v"] = "VISUAL",
    ["vs"] = "VISUAL",
    ["V"] = "LINES",
    ["Vs"] = "LINES",
    [""] = "BLOCK",
    ["s"] = "BLOCK",
    ["s"] = "SELECT",
    ["S"] = "SELECT",
    [""] = "BLOCK",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["ix"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rc"] = "REPLACE",
    ["Rv"] = "V-REPLACE",
    ["Rx"] = "REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "COMMAND",
    ["ce"] = "COMMAND",
    ["r"] = "ENTER",
    ["rm"] = "MORE",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERM",
    ["nt"] = "TERM",
    ["null"] = "NONE",
}

local GIT_INFO = {
    { "added", "", "Added" },
    { "changed", "", "Changed" },
    { "removed", "", "Removed" },
}

--- @param name string
--- @return string
local function hl(name)
    return "%$" .. name .. "$"
end

local function get_os()
    if vim.fn.has("mac") == 1 then
        return "  "
    elseif vim.fn.has("linux") == 1 then
        return "  "
    else
        return "  "
    end
end

local function get_mode()
    return " " .. hl("Error") .. mode_alias[vim.api.nvim_get_mode().mode] .. "   "
end

local function get_filetype_symbol()
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if not ok then
        return ""
    end

    local filetype = vim.bo.buftype == "terminal" and "zsh" or vim.bo.filetype

    local icon, iconhl = devicons.get_icon_by_filetype(filetype, { default = true })

    return hl(iconhl) .. icon
end

local function get_file_info()
    local file_info = " %t"
    if vim.bo.readonly and vim.bo.modified then
        file_info = file_info .. "  " .. " "
    elseif vim.bo.readonly then
        file_info = file_info .. "  "
    elseif vim.bo.modified then
        file_info = file_info .. "  "
    end
    return file_info
end

local function get_git_branch()
    return vim.b.gitsigns_head and hl("Error") .. "  " .. vim.b.gitsigns_head or ""
end

local function get_git_status()
    local dict = vim.b.gitsigns_status_dict or {}
    return vim.iter(GIT_INFO)
        :map(function(val)
            local status = dict[val[1]]
            return status and status > 0 and (" %s%s %d"):format(hl(val[3]), val[2], status) or nil
        end)
        :join("")
end

--- @param sections string[][]
--- @return string
local function parse_sections(sections)
    return vim.iter(sections)
        :map(function(s)
            return table.concat(s)
        end)
        :join("%=")
end

local group = vim.api.nvim_create_augroup("statusline", { clear = true })

vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = group,
    callback = vim.schedule_wrap(function()
        vim.cmd.redrawstatus()
    end),
})

vim.api.nvim_create_autocmd("User", {
    pattern = "GitSignsUpdate",
    group = group,
    callback = vim.schedule_wrap(function()
        vim.cmd.redrawstatus()
    end),
})

local HIGHLIGHT = "%#StatusLine#"

function M.statusline()
    return parse_sections({
        {
            HIGHLIGHT,
            get_mode(),
            HIGHLIGHT,
            get_filetype_symbol(),
            HIGHLIGHT,
            get_file_info(),
            HIGHLIGHT,
            get_git_branch(),
            HIGHLIGHT,
            get_git_status(),
        },
        {
            HIGHLIGHT,
            vim.diagnostic.status():gsub(":", " "),
            HIGHLIGHT,
            get_os(),
            " %2l:%c %3p%% ",
        },
    })
end

vim.o.statusline = "%{%v:lua.require('seblyng.statusline').statusline()%}"

return M
