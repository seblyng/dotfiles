---------- FORMATTER ----------

local function prettierd()
    return {
        exe = "prettierd",
        args = { vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
    }
end

local function latex()
    return {
        exe = "latexindent",
    }
end

require("formatter").setup({
    format_on_save = function()
        return not vim.b.disable_formatting
    end,
    filetype = {
        lua = function()
            return {
                exe = "stylua",
                args = { "--search-parent-directories", "--stdin-filepath", vim.api.nvim_buf_get_name(0), "-" },
            }
        end,
        go = function()
            return {
                exe = "goimports",
            }
        end,
        sql = function()
            return {
                exe = "sql-formatter",
                args = { "-l", "postgresql" },
            }
        end,
        rust = function()
            return {
                exe = "rustfmt",
                args = { "--edition", "2021" },
            }
        end,
        json = function()
            return {
                exe = "jq",
            }
        end,
        cs = function()
            return {
                exe = "dotnet-csharpier",
            }
        end,
        c = function()
            return {
                exe = "clang-format",
            }
        end,
        tex = latex,
        bib = latex,
        javascript = prettierd,
        typescript = prettierd,
        javascriptreact = prettierd,
        typescriptreact = prettierd,
        vue = prettierd,
        css = prettierd,
        scss = prettierd,
        html = prettierd,
        yaml = prettierd,
        markdown = prettierd,
        graphql = prettierd,
    },
})

---------- LSP FORMATTING ----------

local format_clients = {
    "eslint",
}

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if vim.tbl_contains(format_clients, client.name) then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("LspFormat", { clear = true }),
                buffer = args.buf,
                callback = function()
                    if not vim.b.disable_formatting then
                        if client.name == "eslint" then
                            vim.cmd.EslintFixAll()
                        else
                            vim.lsp.buf.format()
                        end
                    end
                end,
                desc = "Formatting lsp",
            })
        end
    end,
})
