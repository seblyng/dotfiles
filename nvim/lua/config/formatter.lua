return {
    "seblyng/nvim-formatter",
    dev = true,
    init = function()
        vim.opt.formatexpr = "v:lua.require('formatter').formatexpr()"
    end,
    opts = {
        format_on_save = function()
            return not vim.b.disable_formatting
        end,
        treesitter = {
            auto_indent = {
                graphql = function()
                    return vim.bo.ft ~= "markdown"
                end,
            },
            disable_injected = {
                rust = { "json" }, -- JSON injections in rust is messed up
                yaml = { "sh", "zsh" },
                dockerfile = { "sh", "zsh" },
            },
        },
        filetype = {
            lua = "stylua --search-parent-directories -",
            go = "goimports",
            sql = "sql-formatter -l postgresql",
            rust = {
                "rustfmt +nightly --edition 2024",
                {
                    exe = "leptosfmt",
                    args = { "--stdin" },
                    cond = function()
                        return vim.fs.root(0, "leptosfmt.toml") ~= nil
                    end,
                },
            },
            terraform = "tofu fmt -",
            json = "jq",
            cs = "csharpier format",
            xml = "csharpier format",
            c = "clang-format",
            tex = "latexindent -g /dev/null",
            bib = "latexindent -g /dev/null",
            javascript = "prettierd .js",
            typescript = "prettierd .ts",
            javascriptreact = "prettierd .jsx",
            typescriptreact = "prettierd .tsx",
            vue = "prettierd .vue",
            css = "prettierd .css",
            scss = "prettierd .scss",
            html = "prettierd .html",
            svg = "prettierd .html",
            yaml = "prettierd .yml",
            markdown = "prettierd .md",
            graphql = "prettierd .gql",
            zsh = "beautysh -",
            sh = "beautysh -",
            typst = "typstyle",
            zig = "zig fmt --stdin",
            _ = "sed s/[[:space:]]*$//",
        },
    },
}
