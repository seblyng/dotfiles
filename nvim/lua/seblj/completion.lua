local function feedkeys(key)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", true)
end

vim.keymap.set("i", "<C-space>", "<C-x><C-o>")

vim.keymap.set("i", "<CR>", function()
    if vim.fn.pumvisible() == 1 and vim.fn.complete_info()["selected"] ~= -1 then
        return feedkeys("<C-y>")
    else
        local ok, npairs = pcall(require, "nvim-autopairs")
        if ok then
            return npairs.autopairs_cr()
        else
            return feedkeys("<CR>")
        end
    end
end, { expr = true, replace_keycodes = false })

local function auto_trigger(bufnr, client)
    vim.api.nvim_create_autocmd("InsertCharPre", {
        buffer = bufnr,
        callback = function()
            -- Do not retrigger if the pum is already visible. This makes the filtering while
            -- typing better as it is not reordering the list while typing.
            -- Also blacklist the parenthesis, since I don't want the completion list if
            -- I potentially can get signature help, as it will overlap
            if vim.fn.pumvisible() == 1 or vim.list_contains({ "(", ")" }, vim.v.char) then
                return
            end

            -- Check to see how nvim-cmp do it, because I don't want it to trigger on space (I think)
            local triggerchars = vim.tbl_get(client, "server_capabilities", "completionProvider", "triggerCharacters")
            if vim.v.char:match("[%w_]") or vim.list_contains(triggerchars or {}, vim.v.char) then
                vim.schedule(function()
                    vim.lsp.completion.trigger()
                end)
            end
        end,
    })
end

local current_win_data = nil

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id) --[[@as vim.lsp.Client]]
        if not client.supports_method("textDocument/completion") then
            return
        end

        local ok, kinds = pcall(require, "lspkind")
        vim.lsp.completion.enable(true, args.data.client_id, args.buf, {
            autotrigger = false,
            convert = function(item)
                local kind_name = vim.lsp.protocol.CompletionItemKind[item.kind]
                local kind = ok and string.format("%s %s", kinds.presets.default[kind_name], kind_name) or kind_name
                return { kind = kind, kind_hlgroup = string.format("CmpItemKind%s", kind_name) }
            end,
        })
        auto_trigger(args.buf, client)

        vim.api.nvim_create_autocmd("CompleteChanged", {
            buffer = args.buf,
            callback = function()
                vim.schedule(function()
                    -- Prevent against error for invalid lnum since we allow for scrolling
                    if current_win_data and vim.api.nvim_win_is_valid(current_win_data.winid) then
                        vim.api.nvim_win_set_cursor(current_win_data.winid, { 1, 0 })
                    end

                    local info = vim.fn.complete_info({ "selected" })
                    local complete = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
                    if complete == nil then
                        return
                    end

                    local resolved = client.request_sync("completionItem/resolve", complete, 500, args.buf) or {}
                    local docs = vim.tbl_get(resolved, "result", "documentation", "value")
                    if docs == nil then
                        return
                    end

                    local contents = vim.split(docs, "\n", { trimempty = true })
                    local scratch = vim.api.nvim_create_buf(false, true)
                    local stylized_docs = table.concat(vim.lsp.util.stylize_markdown(scratch, contents, {}), "\n")

                    local win_data = vim.api.nvim__complete_set(info["selected"], { info = stylized_docs })
                    if not win_data.winid or not vim.api.nvim_win_is_valid(win_data.winid) then
                        return
                    end
                    current_win_data = win_data

                    vim.bo[win_data.bufnr].modifiable = true
                    vim.wo[win_data.winid].conceallevel = 2
                    vim.wo[win_data.winid].wrap = true

                    vim.lsp.util.stylize_markdown(win_data.bufnr, contents, {})
                    vim.api.nvim_win_set_config(win_data.winid, { border = CUSTOM_BORDER })

                    vim.bo[win_data.bufnr].modifiable = false

                    -- Simple scrolling in the preview window
                    local scroll = function(key, dir)
                        vim.keymap.set("i", key, function()
                            if vim.api.nvim_buf_is_valid(win_data.bufnr) then
                                vim.api.nvim_buf_call(win_data.bufnr, function()
                                    vim.cmd(string.format("normal! %s zt", dir))
                                end)
                            else
                                feedkeys("<C-d>")
                            end
                        end, { buffer = args.buf })
                    end

                    scroll("<C-d>", "5j")
                    scroll("<C-u>", "5k")
                end)
            end,
        })
    end,
})

-- completion for directory and files
vim.api.nvim_create_autocmd("InsertCharPre", {
    callback = function(args)
        if vim.fn.pumvisible() == 1 or vim.tbl_contains({ "terminal", "prompt", "help" }, vim.bo[args.buf].buftype) then
            return
        end

        local buf_has_client = #vim.lsp.get_clients({ bufnr = args.buf, method = "textDocument/completion" }) > 0

        local _, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line_text = vim.api.nvim_get_current_line()

        local is_path_related = line_text:sub(col, col):match("[^/][/%w_%-%.~]*")
        if vim.v.char == "/" and col ~= 0 and is_path_related then
            feedkeys("<C-X><C-F>")
        elseif not vim.v.char:match("%s") and not buf_has_client then
            feedkeys("<C-X><C-N>")
        end
    end,
})
