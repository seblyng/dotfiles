return {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
        { "tpope/vim-dadbod", lazy = true },
    },
    cmd = {
        "DBUI",
        "DBUIToggle",
        "DBUIAddConnection",
        "DBUIFindBuffer",
    },
    init = function()
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_disable_mappings = 1
        vim.g.db_ui_execute_on_save = 0

        local original_max_var_type_width = vim.env.SQLCMDMAXVARTYPEWIDTH
        local original_max_fixed_type_width = vim.env.SQLCMDMAXFIXEDTYPEWIDTH

        -- Toggle between original and custom width for columns
        local width = 36
        vim.keymap.set("n", "<leader>tc", function()
            if vim.env.SQLCMDMAXFIXEDTYPEWIDTH == original_max_fixed_type_width then
                vim.env.SQLCMDMAXFIXEDTYPEWIDTH = width
                vim.env.SQLCMDMAXVARTYPEWIDTH = width
                vim.notify("Variable width set to: " .. width)
            else
                vim.env.SQLCMDMAXFIXEDTYPEWIDTH = original_max_fixed_type_width
                vim.env.SQLCMDMAXVARTYPEWIDTH = original_max_var_type_width
                vim.notify("Variable width set back to original")
            end
        end, { desc = "Toggle variable width" })

        local function map(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buffer = true
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        local group = vim.api.nvim_create_augroup("DadbodMappings", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "dbui",
            group = group,
            callback = function()
                map("n", "<CR>", "<Plug>(DBUI_SelectLine)")
                map("n", "R", "<Plug>(DBUI_Redraw)")
                map("n", "d", "<Plug>(DBUI_DeleteLine)")
                map("n", "A", "<Plug>(DBUI_AddConnection)")
                map("n", "H", "<Plug>(DBUI_ToggleDetails)")
                map("n", "r", "<Plug>(DBUI_RenameLine)")
                map("n", "q", "<Plug>(DBUI_Quit)")
            end,
            desc = "Set keymaps for dbui",
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "dbout",
            group = group,
            callback = function()
                map("n", "yh", "<Plug>(DBUI_YankHeader)")
                map("n", "vic", "<Plug>(DBUI_YankCellValue)")
                map("n", "gd", "<Plug>(DBUI_JumpToForeignKey)")
            end,
            desc = "Set keymaps for dadbod sql",
        })

        -- HACK: Override `sqlcmd` just when about to execute a query and restore it after execution
        -- I want to have `-k` argument for sqlcmd: `/path/to/sqlcmd $@ -k 1`
        local path = vim.env.PATH
        vim.api.nvim_create_autocmd({ "User" }, {
            group = group,
            pattern = "DBExecutePre",
            callback = function()
                path = vim.env.PATH -- Update the path directly before executing
                vim.env.PATH = vim.fn.expand("~/.local/bin") .. ":" .. vim.env.PATH
            end,
        })

        vim.api.nvim_create_autocmd({ "User" }, {
            group = group,
            pattern = "DBExecutePost",
            callback = function()
                vim.env.PATH = path
            end,
        })
    end,
}

-- MSSQL connection string example:
-- sqlserver://foo:PORT;database=mydbname;user=myuser@foo;password=mypassword;
