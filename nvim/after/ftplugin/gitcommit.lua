local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
local rebase = vim.iter(lines):find(function(v)
    return string.find(v, "You are currently editing a commit while rebasing branch")
end)

local branch_name = rebase and rebase:match("branch '([^']+)'")
    or vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }):wait().stdout:gsub("\n", "")

local digits = branch_name and branch_name:match(".*%-(%d%d%d%d%d?)$") or nil
if not digits then
    return
end
local branch = string.format("[#%s]", digits)
local start_col, end_col = vim.api.nvim_get_current_line():find("%[#.-%]")
if not start_col or not end_col then
    branch, start_col, end_col = branch .. " ", 1, 0
end

vim.api.nvim_buf_set_text(0, 0, start_col - 1, 0, end_col, { branch })
vim.api.nvim_win_set_cursor(0, { 1, #branch })
