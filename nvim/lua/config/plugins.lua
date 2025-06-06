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

    { "Bekaboo/dropbar.nvim", opts = {} },
    { "j-hui/fidget.nvim", opts = { notification = { override_vim_notify = not EXTUI_ENABLED } } },

    -- Functionality
    { "iamcco/markdown-preview.nvim", build = ":call mkdp#util#install()", ft = "markdown" },
    { "chomosuke/term-edit.nvim", opts = { prompt_end = "➜" }, event = "TermOpen" },
    { "ahonn/resize.vim" },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = { map_cr = vim.g.seblj_completion ~= "native", ignored_next_char = "[%w%.%{%[%(%\"%']" },
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
    { "tpope/vim-sleuth" },
    { "tpope/vim-dispatch" },
}
