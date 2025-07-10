local ns = vim.api.nvim_create_namespace("seblyng_ui")

local options = {
    prefix = " ",
    border_line = "─",
    max_width = 80,
}

local function set_close_mapping(key)
    vim.keymap.set("n", key, function()
        vim.api.nvim_win_close(0, true)
    end, {
        buffer = true,
        desc = "Close popup",
    })
end

local function setup_confirm_mapping(mapping_key, items, on_choice, key)
    vim.keymap.set("n", mapping_key, function()
        local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_win_set_cursor(0, { row, 1 })
        local choice = key and key or tonumber(vim.fn.expand("<cword>"))
        vim.api.nvim_win_close(0, true)
        on_choice(items[choice], choice)
    end, {
        buffer = true,
        desc = "Confirm selection",
    })
end

local function set_highlight(buf, title, width)
    vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, { end_col = #title, hl_group = "Title" })
    vim.api.nvim_buf_set_extmark(buf, ns, 1, 0, {
        virt_text_win_col = 0,
        virt_text = { { string.rep(options.border_line, width), "@punctuation.special.markdown" } },
        priority = 100,
    })
end

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(items, opts, on_choice)
    vim.schedule(function()
        if vim.tbl_isempty(items) then
            return vim.notify("No items to choose from")
        end

        if vim.api.nvim_get_mode().mode ~= "n" then
            vim.api.nvim_input("<ESC>")
        end
        local format_item = opts.format_item or tostring
        local choices = vim.iter(pairs(items))
            :map(function(i, item)
                return string.format("[%d] %s", i, format_item(item))
            end)
            :totable()

        local title = opts.prompt or "Select one of:"
        local width = vim.iter(choices):fold(#title, function(acc, line)
            local strlen = math.max(vim.fn.strdisplaywidth(line), acc)
            return strlen > options.max_width and options.max_width or strlen
        end)

        local lines = { title, string.rep(options.border_line, width), unpack(choices) }
        local popup_bufnr, winnr = vim.lsp.util.open_floating_preview(lines, opts.syntax, {
            max_width = options.max_width,
        })

        vim.api.nvim_set_current_win(winnr)
        set_close_mapping("<Esc>")
        set_close_mapping("q")

        vim.keymap.set("n", "j", "j", { buffer = true })
        vim.keymap.set("n", "k", "k", { buffer = true })

        vim.schedule(function()
            require("seblyng.utils").setup_hidden_cursor()
        end)

        vim.api.nvim_create_autocmd("CursorMoved", {
            group = vim.api.nvim_create_augroup("UISetCursor", { clear = true }),
            pattern = "<buffer>",
            callback = function()
                if vim.fn.line(".") < 3 and vim.api.nvim_buf_line_count(0) >= 3 then
                    vim.api.nvim_win_set_cursor(0, { 3, 1 })
                end
            end,
            desc = "Hidden cursor",
        })

        setup_confirm_mapping("<CR>", items, on_choice)

        vim.api.nvim_win_set_cursor(winnr, { math.ceil(#title / width) + 2, 1 })
        set_highlight(popup_bufnr, title, width)

        for k = 1, #choices do
            setup_confirm_mapping(string.format("%d", k), items, on_choice, k)
        end
    end)
end

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.input = function(opts, on_confirm)
    vim.schedule(function()
        local default_length = opts.default and #opts.default or 0
        local calculated_with = math.max(30, #opts.prompt + #options.prefix, default_length + #options.prefix)
        local width = math.min(calculated_with, options.max_width)

        local lines = { opts.prompt, string.rep(options.border_line, width) }

        local popup_bufnr, winnr = vim.lsp.util.open_floating_preview(lines, opts.syntax, {
            width = width,
            height = math.ceil(#opts.prompt / width) + 2,
            wrap = false,
        })

        vim.api.nvim_set_current_win(winnr)

        set_close_mapping("<Esc>")
        set_close_mapping("q")

        vim.keymap.set({ "i", "n" }, "<CR>", function()
            local input = vim.trim(vim.fn.getline("."):sub(#options.prefix + 1, -1))
            vim.api.nvim_win_close(0, true)
            on_confirm(input)
            vim.cmd.stopinsert()
        end, {
            buffer = true,
            desc = "Confirm selection",
        })

        vim.cmd.startinsert()
        vim.bo[popup_bufnr].modifiable = true
        vim.bo[popup_bufnr].buftype = "prompt"
        vim.fn.prompt_setprompt(popup_bufnr, options.prefix)
        if opts.default and #opts.default ~= 0 then
            vim.api.nvim_input(string.format("%s<Esc>0wv$h<C-g>", opts.default))
        end
        set_highlight(popup_bufnr, lines[1], width)
        vim.api.nvim_buf_set_extmark(popup_bufnr, ns, 2, 0, {
            virt_text_win_col = 0,
            virt_text = { { options.prefix, "Title" } },
        })
    end)
end
