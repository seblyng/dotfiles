if not pcall(require, "vim._core.intro") then
    vim.pack.add({
        { src = "https://github.com/mhinz/vim-startify" },
    })
    return
end

local commands = {
    { label = "Dotfiles", action = "lua vim.api.nvim_input('<space>fd')" },
    { label = "Pack sync", action = "Pack sync" },
    { label = "Pack update", action = "Pack update" },
    { label = "StartupTime", action = "StartupTime" },
}

local items = {}
local selected = 1

local function build_selection()
    local max_width = 0
    for i, item in ipairs(items) do
        local idx = string.format("[%d] ", i - 1)
        local w = #idx + vim.api.nvim_strwidth(item.label) + (item.icon and vim.api.nvim_strwidth(item.icon) or 0)
        max_width = math.max(max_width, w)
    end

    local sep = ("─"):rep(max_width)
    local sel = {}
    for i, item in ipairs(items) do
        if i == #commands + 1 then
            table.insert(sel, { { sep, "NonText" } })
        end
        local idx = string.format("[%d] ", i - 1)
        local hl = i == selected and "Error" or "Normal"
        local chunks = { { idx, "Special" } }
        if item.icon then
            table.insert(chunks, { item.icon, item.icon_hl })
        end
        local w = #idx + vim.api.nvim_strwidth(item.label) + (item.icon and vim.api.nvim_strwidth(item.icon) or 0)
        table.insert(chunks, { item.label .. string.rep(" ", max_width - w), hl })
        table.insert(sel, chunks)
    end
    return sel, sep
end

local ns_id = vim.api.nvim_create_namespace("seb_intro")
require("vim._core.intro").display = function()
    if #items == 0 then
        items = vim.list_extend({}, commands)
        local devicons = require("nvim-web-devicons")
        for i = 1, math.min(6, #vim.v.oldfiles) do
            local path = vim.v.oldfiles[i]
            local icon, hl = devicons.get_icon(path, nil, { default = true })
            local label = vim.fn.fnamemodify(path, ":~:.")
            local action = string.format("edit %s", vim.fn.fnameescape(path))
            table.insert(items, { label = label, icon = string.format("%s ", icon), icon_hl = hl, action = action })
        end
    end

    vim.on_key(function(_, key)
        if key == "" then
            return ""
        end

        local mode = vim.api.nvim_get_mode().mode
        if mode ~= "n" and mode ~= "r" then
            return
        end

        local num = tonumber(key)
        if key == "j" or key == vim.keycode("<Down>") then
            selected = math.min(selected + 1, #items)
        elseif key == "J" then
            selected = math.min(selected + 10, #items)
        elseif key == "k" or key == vim.keycode("<Up>") then
            selected = math.max(selected - 1, 1)
        elseif key == "K" then
            selected = math.max(selected - 10, 1)
        elseif key == vim.keycode("<CR>") then
            vim.cmd(items[selected].action)
            require("vim._core.intro").dismiss()
        elseif key == vim.keycode("<Esc>") then
            return ""
        elseif num and num >= 0 and num < #items then
            vim.cmd(items[num + 1].action)
            require("vim._core.intro").dismiss()
        else
            return
        end
        vim.schedule(vim.cmd.redraw)
        return ""
    end, ns_id)

    local sel, sep = build_selection()
    return vim.list_extend(vim.deepcopy(require("vim._core.intro").logo), {
        {},
        { { ("NVIM %s"):format(tostring(vim.version())), "String" } },
        { { sep, "NonText" } },
        unpack(sel),
    })
end

require("vim._core.intro").on_close = function()
    vim.on_key(nil, ns_id)
end
