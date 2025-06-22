-- Doesn't work with neotest: https://github.com/willothy/flatten.nvim/issues/106
if true then
    return {}
end
-- Avoid nested sessions when using term, and do not depend on third party software like nvr
-- Automatically return to the terminal when doing a rebase or commit. Otherwise, just open it
-- in the current buffer as it should behave by default
return {
    "willothy/flatten.nvim",
    opts = {
        hooks = {
            pre_open = function()
                local termid = vim.api.nvim_get_current_buf()
                if vim.bo[termid].buftype == "terminal" then
                    vim.g.seblyng_flatten_saved_terminal = termid
                end
            end,
            post_open = function(opts)
                if opts.filetype == "gitcommit" or opts.filetype == "gitrebase" then
                    vim.api.nvim_create_autocmd("QuitPre", {
                        buffer = opts.bufnr,
                        once = true,
                        callback = vim.schedule_wrap(function()
                            -- Would be nice to cancel the exit here to keep the split size
                            vim.cmd.split()
                            if vim.g.seblyng_flatten_saved_terminal then
                                vim.api.nvim_set_current_buf(vim.g.seblyng_flatten_saved_terminal)
                            end
                            vim.api.nvim_buf_delete(opts.bufnr, {})
                        end),
                    })
                end
            end,
            block_end = vim.schedule_wrap(function()
                if vim.g.seblyng_flatten_saved_terminal then
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        if vim.api.nvim_win_get_buf(win) == vim.g.seblyng_flatten_saved_terminal then
                            vim.api.nvim_set_current_win(win)
                            break
                        end
                    end

                    vim.g.seblyng_flatten_saved_terminal = nil
                end
            end),
        },
    },
}
