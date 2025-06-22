local runners = {
    cs = function()
        return require("seblyng.testrunner.runners.dotnet")
    end,
    rust = function()
        return require("seblyng.testrunner.runners.cargo")
    end,
}

---@param debug? boolean
local function run(debug)
    local ok, runner = pcall(runners[vim.bo.filetype])
    if not ok or not runner then
        return vim.notify(string.format("No testrunner found for %s", vim.bo.filetype), vim.log.levels.ERROR)
    end

    if not runner.is_test_file() then
        return vim.notify("File is not a testfile")
    end

    local captures = runner.find_nearest_captures(runner.query)
    if vim.tbl_isempty(captures or {}) then
        return vim.notify("Couldn't find any tests")
    end

    require("seblyng.utils").wrap_lcd(function()
        local cmd = runner:generate_cmd(captures, debug)

        require("seblyng.utils").term({ direction = "new", focus = false, cmd = cmd })
    end, runner.root())
end

-- vim.keymap.set("n", "<leader>tt", function()
--     run()
-- end)
--
-- vim.keymap.set("n", "<leader>td", function()
--     run(true)
-- end)
