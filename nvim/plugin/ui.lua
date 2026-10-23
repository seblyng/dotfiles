local ns = vim.api.nvim_create_namespace("seblyng_ui")

local prefix = " "

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.input = function(opts, on_confirm)
    opts = opts or {}
    vim.schedule(function()
        local prompt = opts.prompt or "Input: "
        local default = opts.default or ""
        local prompt_width = vim.api.nvim_strwidth(prompt)
        local default_width = vim.api.nvim_strwidth(prefix .. default)

        local width = math.min(80, math.max(30, prompt_width, default_width))
        local lines = { prompt, string.rep("─", width), " " }
        local buf, winnr = vim.lsp.util.open_floating_preview(lines, "", { width = width, height = 3, wrap = false })

        vim.api.nvim_set_current_win(winnr)

        local function finish(value)
            vim.cmd.stopinsert()
            vim.api.nvim_win_close(winnr, true)
            on_confirm(value)
        end

        local function cancel()
            finish(nil)
        end

        vim.bo[buf].modifiable = true
        vim.bo[buf].buftype = "prompt"

        vim.fn.prompt_setprompt(buf, prefix)
        vim.fn.prompt_setcallback(buf, finish)
        vim.fn.prompt_setinterrupt(buf, cancel)

        vim.keymap.set("n", "<Esc>", cancel, { buf = buf })
        vim.keymap.set("n", "<CR>", "A<CR>", { buf = buf })

        vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, { end_col = #lines[1], hl_group = "Title" })
        vim.api.nvim_buf_set_extmark(buf, ns, 1, 0, { end_col = #lines[2], hl_group = "@punctuation.special.markdown" })
        vim.api.nvim_buf_set_extmark(buf, ns, 2, 0, { virt_text_win_col = 0, virt_text = { { prefix, "Title" } } })

        vim.cmd.startinsert()
        if default ~= "" then
            vim.api.nvim_input(string.format("%s<Esc>0wv$h<C-g>", default))
        end
    end)
end
