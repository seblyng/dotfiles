return {
    { "seblyng/nvim-tabline", opts = {}, event = "TabNew", dev = true },

    -- TODO: Either make it work with injections or look into only using this if it is a "leptos" file
    -- { "rayliwell/tree-sitter-rstml", opts = {}, dev = true },
    { "seblyng/nvim-ts-autotag", opts = {}, event = { "BufReadPost", "BufNewFile" }, dev = true },

    {
        "github/copilot.vim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            vim.g.copilot_enabled = 0
            vim.g.copilot_filetypes = { bigfile = false }
        end,
    },

    -- Git
    { "akinsho/git-conflict.nvim", opts = {}, event = { "BufReadPre", "BufWritePre" } },

    -- Packageinfo
    { "saecki/crates.nvim", opts = {}, event = "BufReadPre Cargo.toml" },
    { "vuki656/package-info.nvim", opts = {}, event = "BufReadPre package.json" },

    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- UI
    {
        "brenoprata10/nvim-highlight-colors",
        opts = { exclude_filetypes = { "yaml" } },
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        "Bekaboo/dropbar.nvim",
        opts = {
            bar = {
                enable = function(buf, win)
                    return not vim.api.nvim_win_get_config(win).zindex
                        and vim.bo[buf].buftype == ""
                        and vim.api.nvim_buf_get_name(buf) ~= ""
                        and not vim.wo[win].diff
                end,
            },
        },
        cond = not (vim.uv.os_uname().sysname == "Windows_NT"),
    },
    {
        "j-hui/fidget.nvim",
        opts = { notification = { override_vim_notify = true } },
    },

    -- Functionality
    { "iamcco/markdown-preview.nvim", build = ":call mkdp#util#install()", ft = "markdown" },
    { "chomosuke/term-edit.nvim", opts = { prompt_end = "➜" }, event = "TermOpen" },
    { "ahonn/resize.vim" },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            disable_filetype = { "snacks_picker_input" },
            map_cr = vim.g.seblj_completion ~= "native",
            ignored_next_char = "[%w%.%{%[%(%\"%']",
        },
    },
    { "lambdalisue/vim-suda", keys = { { "w!!", "SudaWrite", mode = "ca" } }, lazy = false },

    -- Tpope
    { "tpope/vim-repeat" },
    { "tpope/vim-abolish" },
    { "tpope/vim-unimpaired" },
    {
        "tpope/vim-surround",
        keys = {
            { "s", "<Plug>Ysurround", desc = "Surround with motion" },
            { "S", "<Plug>Yssurround", desc = "Surround entire line" },
            { "s", "<Plug>VSurround", mode = "x", desc = "Surround visual" },
        },
        lazy = false,
    },
    { "tpope/vim-scriptease" },
    { "tpope/vim-sleuth" },
    { "tpope/vim-dispatch" },
}
