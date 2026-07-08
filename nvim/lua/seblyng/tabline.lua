local function highlight(name)
    return "%#" .. name .. "#"
end

local function devicon(bufnr)
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if not ok then
        return ""
    end

    local filetype = vim.bo[bufnr].filetype
    local buftype = vim.bo[bufnr].buftype

    filetype = buftype == "terminal" and "zsh" or filetype

    local icon, iconhl = devicons.get_icon_by_filetype(filetype, { default = true })

    return "%$" .. iconhl .. "$" .. icon
end

local function get_file_info(bufnr)
    local bufname = vim.fn.bufname(bufnr)
    local tabname = vim.fn.fnamemodify(bufname, ":t")

    local file_info = tabname == "" and "[No Name]" or tabname
    if vim.bo[bufnr].readonly and vim.bo[bufnr].modified then
        file_info = file_info .. "  " .. " "
    elseif vim.bo[bufnr].readonly then
        file_info = file_info .. "  "
    elseif vim.bo[bufnr].modified then
        file_info = file_info .. "  "
    end
    return file_info
end

local function close_icon(index, bufnr, base)
    if vim.bo[bufnr].modified then
        return ""
    end

    return "%" .. index .. "X" .. highlight(base) .. " %*%X"
end

local function get_diagnostics(bufnr)
    local status = vim.diagnostic.status(bufnr)
    if status == "" then
        return ""
    end

    return " " .. status:gsub(":", " "):gsub("#", "$")
end

local M = {}

function M.tabline()
    local parts = {}
    for index in pairs(vim.api.nvim_list_tabpages()) do
        local winnr = vim.fn.tabpagewinnr(index)
        local bufnr = vim.fn.tabpagebuflist(index)[winnr]
        local selected = index == vim.fn.tabpagenr()

        local base = selected and "TabLineSel" or "TabLineFill"

        parts[#parts + 1] = string.format(
            "%s%%%dT %s %s%s%s %s",
            highlight(base),
            index,
            devicon(bufnr),
            highlight(base),
            get_file_info(bufnr),
            get_diagnostics(bufnr) .. highlight(base),
            close_icon(index, bufnr, base)
        )
    end
    return table.concat(parts) .. "%#TabLineFill#%="
end

vim.opt.tabline = "%!v:lua.require'seblyng.tabline'.tabline()"

return M
