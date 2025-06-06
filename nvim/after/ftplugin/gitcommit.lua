local function try_insert_branch(branch_name)
    if vim.regex([[\(chore\|bug\|story\|task\|epic\)-\d\{4,5}]]):match_str(branch_name or "") then
        local line = vim.api.nvim_get_current_line()
        local branch = "[#" .. branch_name:match("^%a+%-(%d+)") .. "]"
        local branch_pattern = "%[#.-%]"
        -- Don't do anything if the branch is already in the first line
        local start_col, end_col = string.find(line, branch_pattern)
        if start_col and end_col then
            vim.api.nvim_buf_set_text(0, 0, start_col - 1, 0, end_col, { branch })
            return
        end

        vim.api.nvim_buf_set_lines(0, 0, 0, false, { branch .. " " .. line })
        -- nvim_buf_set_lines creates a new line for some reason so delete it
        vim.cmd.normal({ "2Gdd" })
        vim.api.nvim_win_set_cursor(0, { 1, #branch })
    end
end

local branch = vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }):wait().stdout:gsub("\n", "") or ""

-- We are in a rebase and need to find the name in a clever way
if branch == "HEAD" then
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local line = vim.iter(lines):find(function(v)
        return string.find(v, "You are currently editing a commit while rebasing branch")
    end)

    local b = string.match(line or "", "'([^']+)'")
    try_insert_branch(b)
else
    try_insert_branch(branch)
end
