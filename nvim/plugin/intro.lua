vim.pack.add({
    "https://github.com/mhinz/vim-startify",
})
if true then
    return
end

if vim.fn.argc() > 0 then
    return
end

vim.opt.shortmess:append("I")

local MIN_WIDTH = 74

local version_line = ("NVIM v%s"):format(tostring(vim.version()))

local ns_id = vim.api.nvim_create_namespace("intro")

local get_icons = function(path)
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if not ok then
        return nil, nil
    end

    local icon, hl = devicons.get_icon(path, nil, { default = true })
    return icon and icon .. " " or "", hl
end

local function build_rows()
    local rows = {
        { text = "│ ╲ ││", align = "center" },
        { text = "││╲╲││", align = "center" },
        { text = "││ ╲ │", align = "center" },
        { text = "", align = "center" },
        { text = version_line, align = "center" },
        { separator = true },
        { text = "[0] Dotfiles", align = "left", action = "lua vim.api.nvim_input('<space>fd')" },
        { text = "[1] Pack sync", align = "left", action = "Pack sync" },
        { text = "[2] Pack update", align = "left", action = "Pack update" },
        { text = "[3] StartupTime", align = "left", action = "StartupTime" },
        { separator = true },
    }

    local start = 4
    for i = 1, 5 do
        local path = vim.v.oldfiles[i]
        local icon, hl = get_icons(path)
        table.insert(rows, {
            text = string.format("[%s] %s%s", i + start - 1, icon, vim.fn.fnamemodify(path, ":~:.")),
            icon = icon,
            icon_hl = hl,
            action = string.format("edit %s", vim.fn.fnameescape(path)),
        })
    end

    return rows
end

--- @param layout_rows table[]
--- @param width integer
--- @return string[]
local function render_rows(layout_rows, width)
    local rendered = {}
    for i, row in ipairs(layout_rows) do
        local line = row.separator and string.rep("─", width) or row.text
        local line_width = vim.fn.strdisplaywidth(line)

        local padding = row.align == "center" and string.rep(" ", math.floor((width - line_width) / 2)) or ""
        rendered[i] = padding .. line
    end
    return rendered
end

local function hl_match(lines, line_idx, text, hl_group)
    local col_start = assert(lines[line_idx]:find(text, 1, true)) - 1
    return { line_idx, col_start, col_start + #text, hl_group }
end

local function build_hl_ranges(rows, lines)
    local hl_ranges = {
        hl_match(lines, 1, "│", "IntroBlue"),
        hl_match(lines, 1, "╲ ││", "IntroGreen"),
        hl_match(lines, 2, "││", "IntroBlue"),
        hl_match(lines, 2, "╲╲││", "IntroGreen"),
        hl_match(lines, 3, "││", "IntroBlue"),
        hl_match(lines, 3, "╲ │", "IntroGreen"),
        hl_match(lines, 5, version_line, "String"),
    }

    for line, row in ipairs(rows) do
        if row.separator then
            hl_ranges[#hl_ranges + 1] = { line, 0, #lines[line], "NonText" }
        elseif row.icon and row.icon_hl then
            hl_ranges[#hl_ranges + 1] = hl_match(lines, line, row.icon, row.icon_hl)
        end
    end

    return hl_ranges
end

local function show_intro()
    vim.cmd.enew()

    local rows = build_rows()

    local width = MIN_WIDTH
    for _, row in ipairs(rows) do
        width = math.max(width, vim.fn.strdisplaywidth(row.text or ""))
    end

    local lines = render_rows(rows, width)
    require("seblyng.utils").setup_hidden_cursor()
    vim.bo[0].bufhidden = "wipe"
    vim.bo[0].buflisted = false
    vim.bo[0].buftype = "nofile"
    vim.bo[0].swapfile = false
    vim.bo[0].filetype = "intro"
    vim.bo[0].matchpairs = ""

    vim.wo[0][0].colorcolumn = ""
    vim.wo[0][0].foldcolumn = "0"
    vim.wo[0][0].list = false
    vim.wo[0][0].number = false
    vim.wo[0][0].relativenumber = false
    vim.wo[0][0].signcolumn = "no"

    local item_rows = {}
    for line, row in ipairs(rows) do
        if row.action then
            item_rows[#item_rows + 1] = line
        end
    end

    local top_padding = 0
    local left_padding = 0
    local selected_idx = 1
    local buf = vim.api.nvim_get_current_buf()
    local group = vim.api.nvim_create_augroup("seblyng_intro_" .. buf, { clear = true })

    local function item_screen_line(idx)
        return top_padding + item_rows[idx]
    end

    local function render_intro(win)
        if not (vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_win_is_valid(win)) then
            return
        end

        top_padding = math.max(0, math.floor((vim.api.nvim_win_get_height(win) - #lines) / 2))
        left_padding = math.max(0, math.floor((vim.api.nvim_win_get_width(win) - width) / 2))

        local padded_lines = {}
        for _ = 1, top_padding do
            padded_lines[#padded_lines + 1] = ""
        end
        for _, line in ipairs(lines) do
            padded_lines[#padded_lines + 1] = string.rep(" ", left_padding) .. line
        end

        vim.bo[buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, padded_lines)
        vim.bo[buf].modifiable = false
        vim.bo[buf].modified = false

        vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
        vim.api.nvim_set_hl(0, "IntroBlue", { fg = "#3E93D3" })
        vim.api.nvim_set_hl(0, "IntroGreen", { fg = "#69A33E" })
        for _, range in ipairs(build_hl_ranges(rows, lines)) do
            vim.api.nvim_buf_set_extmark(buf, ns_id, top_padding + range[1] - 1, left_padding + range[2], {
                end_row = top_padding + range[1] - 1,
                end_col = left_padding + range[3],
                hl_group = range[4],
            })
        end

        vim.api.nvim_win_call(win, function()
            vim.fn.winrestview({ topline = 1 })
        end)
        vim.api.nvim_win_set_cursor(win, { item_screen_line(selected_idx), left_padding + 1 })
    end

    render_intro(vim.api.nvim_get_current_win())

    vim.keymap.set("n", "<CR>", function()
        vim.cmd(rows[item_rows[selected_idx]].action)
    end, { buf = buf })

    for idx, line in ipairs(item_rows) do
        vim.keymap.set("n", tostring(idx - 1), function()
            vim.cmd(rows[line].action)
        end, { buf = buf })
    end

    vim.api.nvim_create_autocmd("CursorMoved", {
        group = group,
        buffer = buf,
        callback = function()
            local row = vim.api.nvim_win_get_cursor(0)[1]
            local item_row = item_screen_line(selected_idx)
            local step = row > item_row and 1 or -1

            while item_rows[selected_idx + step] and (row - item_row) * step > 0 do
                selected_idx = selected_idx + step
                item_row = item_screen_line(selected_idx)
            end

            vim.api.nvim_win_set_cursor(0, { item_row, left_padding + 1 })
        end,
    })

    vim.api.nvim_create_autocmd({ "VimResized", "WinResized", "WinEnter", "WinLeave" }, {
        group = group,
        buffer = buf,
        callback = function()
            for _, win in ipairs(vim.fn.win_findbuf(buf)) do
                render_intro(win)
            end
        end,
    })

    vim.api.nvim_create_autocmd("BufWipeout", {
        group = group,
        buffer = buf,
        callback = function()
            pcall(vim.api.nvim_del_augroup_by_id, group)
        end,
    })
end

vim.api.nvim_create_autocmd("VimEnter", { once = true, callback = show_intro })
vim.api.nvim_create_user_command("Intro", show_intro, {})
