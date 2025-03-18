local group = vim.api.nvim_create_augroup("SebCompletion", { clear = true })

local function feedkeys(key)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", true)
end

vim.keymap.set("i", "<C-space>", vim.lsp.completion.get)

vim.keymap.set("i", "<CR>", function()
    if vim.fn.complete_info()["selected"] ~= -1 then
        return feedkeys("<C-y>")
    else
        local ok, npairs = pcall(require, "nvim-autopairs")
        return ok and npairs.autopairs_cr() or feedkeys("<CR>")
    end
end, { expr = true, replace_keycodes = false, desc = "Accept completion" })

local current_win_data = nil

vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or not client:supports_method("textDocument/completion") then
            return
        end

        -- Some weird things happening when `volar` is started as well as `ts_ls`.
        -- It adds an extra `.` sometimes, but I cannot figure out why
        if client.name == "volar" then
            return
        end

        local ok, kinds = pcall(require, "lspkind")
        vim.lsp.completion.enable(true, client.id, args.buf, {
            autotrigger = true,
            convert = function(item)
                local kind_name = vim.lsp.protocol.CompletionItemKind[item.kind]
                local kind = ok and string.format("%s", kinds.presets.default[kind_name]) or kind_name
                return { kind = kind, kind_hlgroup = string.format("CmpItemKind%s", kind_name) }
            end,
        })

        vim.api.nvim_create_autocmd("CompleteChanged", {
            group = group,
            buffer = args.buf,
            callback = function()
                vim.schedule(function()
                    -- Prevent against error for invalid lnum since we allow for scrolling
                    if current_win_data and vim.api.nvim_win_is_valid(current_win_data.winid) then
                        vim.api.nvim_win_set_cursor(current_win_data.winid, { 1, 0 })
                    end

                    local complete = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
                    if complete == nil then
                        return
                    end

                    local resolved = client:request_sync("completionItem/resolve", complete, 500, args.buf) or {}
                    local docs = vim.tbl_get(resolved, "result", "documentation", "value")
                    if docs == nil then
                        return
                    end

                    local win = vim.api.nvim__complete_set(vim.fn.complete_info().selected, { info = docs })
                    if not win.winid or not vim.api.nvim_win_is_valid(win.winid) then
                        return
                    end
                    current_win_data = win

                    local conceal_height = vim.api.nvim_win_text_height(win.winid, {}).all
                    local max_height = math.floor(40 * (40 / vim.o.lines))
                    local height = conceal_height > max_height and max_height or conceal_height
                    vim.api.nvim_win_set_height(win.winid, height)

                    vim.wo[win.winid].conceallevel = 2
                    vim.treesitter.start(win.bufnr, "markdown")

                    vim.api.nvim_win_set_config(win.winid, { border = CUSTOM_BORDER })

                    -- Simple scrolling in the preview window
                    local scroll = function(key, dir)
                        vim.keymap.set("i", key, function()
                            if vim.api.nvim_buf_is_valid(win.bufnr) then
                                vim.api.nvim_buf_call(win.bufnr, function()
                                    vim.cmd(string.format("normal! %s zt", dir))
                                end)
                            else
                                feedkeys(key)
                            end
                        end, { buffer = args.buf })
                    end

                    scroll("<C-d>", "5j")
                    scroll("<C-u>", "5k")
                end)
            end,
        })

        if #vim.api.nvim_get_autocmds({ buffer = args.buf, event = "InsertCharPre", group = group }) ~= 0 then
            return
        end

        vim.api.nvim_create_autocmd("InsertCharPre", {
            buffer = args.buf,
            group = group,
            callback = function()
                if vim.fn.pumvisible() == 1 then
                    return
                end
                local triggers = vim.tbl_get(client, "server_capabilities", "completionProvider", "triggerCharacters")
                if vim.v.char:match("[%w_]") and not vim.list_contains(triggers or {}, vim.v.char) then
                    vim.schedule(function()
                        vim.lsp.completion.get()
                    end)
                end
            end,
        })
    end,
})

local function should_complete_file()
    -- It stops completing when "accepting" since it includes trailing slash for dirs
    local _, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line_text = vim.api.nvim_get_current_line()
    if line_text:sub(col, col) == "/" and vim.v.char:match("%S") then
        return true
    end

    -- Trigger chars for normal cases
    if not vim.list_contains({ "/" }, vim.v.char) then
        return false
    end

    -- Some inspiration from nvim-cmp for when to do path completion
    local prefix = line_text:sub(1, col) .. vim.v.char
    return not (
        prefix:match("%a+://?$") -- Ignore URL scheme
        or prefix:match("</$") -- Ignore HTML closing tags
        or prefix:match("[%d%)]%s*/$") -- Ignore math calculation
        or (prefix:match("^[%s/]*$") and vim.bo.commentstring:match("/[%*/]")) -- Ignore / comment
    )
end

vim.api.nvim_create_autocmd("CompleteChanged", {
    group = vim.api.nvim_create_augroup("SebCompleteChangedFiles", { clear = true }),
    callback = function()
        vim.schedule(function()
            local info = vim.fn.complete_info({ "selected", "mode" })
            -- Strip the final `/` to automatically continue completion
            if info.selected ~= -1 and info.mode == "files" then
                local line = vim.api.nvim_get_current_line():gsub("/$", "")
                vim.api.nvim_set_current_line(line)
            end
        end)
    end,
})

-- Completion for path (and omni if no language server is attached to buffer)
vim.api.nvim_create_autocmd("InsertCharPre", {
    callback = function(args)
        local invalid_buftype = vim.list_contains({ "terminal", "prompt", "help" }, vim.bo[args.buf].buftype)
        if vim.fn.pumvisible() == 1 or invalid_buftype then
            return
        end

        local buf_has_client = #vim.lsp.get_clients({ bufnr = args.buf, method = "textDocument/completion" }) > 0

        if should_complete_file() then
            feedkeys("<C-X><C-F>")
        elseif not vim.v.char:match("%s") and not buf_has_client then
            feedkeys("<C-X><C-N>")
        end
    end,
})
