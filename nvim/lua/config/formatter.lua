vim.pack.add({
    { src = "https://github.com/seblyng/nvim-formatter", data = { dev = true } },
})

vim.opt.formatexpr = "v:lua.require('formatter').formatexpr()"

require("formatter").setup({
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
        rust = "rustfmt +nightly --edition 2024",
        terraform = "tofu fmt -",
        json = "jq",
        cs = "csharpier format",
        xml = "csharpier format",
        c = "clang-format",
        tex = "latexindent -g /dev/null",
        bib = "latexindent -g /dev/null",
        javascript = "oxfmt --stdin-filepath file.js",
        typescript = "oxfmt --stdin-filepath file.ts",
        javascriptreact = "oxfmt --stdin-filepath file.jsx",
        typescriptreact = "oxfmt --stdin-filepath file.tsx",
        vue = "oxfmt --stdin-filepath file.vue",
        css = "oxfmt --stdin-filepath file.css",
        scss = "oxfmt --stdin-filepath file.scss",
        html = "oxfmt --stdin-filepath file.html",
        svg = "oxfmt --stdin-filepath file.html",
        yaml = "oxfmt --stdin-filepath file.yml",
        markdown = "oxfmt --stdin-filepath file.md",
        graphql = "oxfmt --stdin-filepath file.gql",
        zsh = "beautysh -",
        sh = "beautysh -",
        typst = "typstyle",
        zig = "zig fmt --stdin",
        rego = "opa fmt",
        _ = "sed s/[[:space:]]*$//",
    },
})
