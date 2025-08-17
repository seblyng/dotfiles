local function highlight(name)
    return "%#" .. name .. "#"
end

local devicon_hl = {}

local function devicon(bufnr, base)
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if not ok then
        return ""
    end

    local filetype = vim.bo[bufnr].filetype
    local buftype = vim.bo[bufnr].buftype

    filetype = buftype == "terminal" and "zsh" or filetype

    local icon, iconhl = devicons.get_icon_color_by_filetype(filetype, { default = true })

    local hlname = "SebTabline" .. base .. iconhl:gsub("#", "")
    if not devicon_hl[hlname] then
        devicon_hl[hlname] = true
        vim.api.nvim_set_hl(0, hlname, {
            fg = iconhl,
            bg = vim.api.nvim_get_hl(0, { name = base }).bg,
        })
    end

    return "%#" .. hlname .. "#" .. icon
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

local DIAGNOSTICS = {
    { "Error", "", "DiagnosticError" },
    { "Warn", "", "DiagnosticWarn" },
    { "Info", "I", "DiagnosticInfo" },
    { "Hint", "", "DiagnosticHint" },
}

local function get_diagnostics(bufnr, base)
    local diags = vim.diagnostic.count(bufnr)
    local res = vim.iter(DIAGNOSTICS)
        :enumerate()
        :map(function(i, attrs)
            local n = diags[i] or 0
            if n > 0 then
                return ("%s%s %d"):format(highlight(attrs[3] .. base), attrs[2], n)
            end
        end)
        :join(" ")

    return res == "" and "" or " " .. res
end

local function hldefs()
    for _, hl_base in ipairs({ "TabLineSel", "TabLineFill" }) do
        local bg = vim.api.nvim_get_hl(0, { name = hl_base }).bg
        for _, ty in ipairs({ "Warn", "Error", "Info", "Hint" }) do
            local fg = vim.api.nvim_get_hl(0, { name = "Diagnostic" .. ty }).fg
            local name = ("Diagnostic%s%s"):format(ty, hl_base)
            vim.api.nvim_set_hl(0, name, { fg = fg, bg = bg })
        end
    end
end

vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("SebTabline", { clear = true }),
    callback = hldefs,
})

hldefs()

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
            devicon(bufnr, base),
            highlight(base),
            get_file_info(bufnr),
            get_diagnostics(bufnr, base),
            close_icon(index, bufnr, base)
        )
    end
    return table.concat(parts) .. "%#TabLineFill#%="
end

vim.opt.tabline = "%!v:lua.require'seblyng.tabline'.tabline()"

return M
