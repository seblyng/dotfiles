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
        buf = 0,
        desc = "Close popup",
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
vim.ui.input = function(opts, on_confirm)
    vim.schedule(function()
        local default_length = opts.default and #opts.default or 0
        local calculated_with = math.max(30, #opts.prompt + #options.prefix, default_length + #options.prefix)
        local width = math.min(calculated_with, options.max_width)

        local lines = { opts.prompt, string.rep(options.border_line, width), opts.default or " " }

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
            buf = 0,
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
