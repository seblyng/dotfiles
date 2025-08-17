return {
    { "seblyng/nvim-ts-autotag", dev = true },

    { "github/copilot.vim", event = { "BufReadPre", "BufNewFile" } },

    { "seblyng/git-conflict.nvim", dev = true },

    -- Packageinfo
    { "saecki/crates.nvim", opts = {}, event = "BufReadPre Cargo.toml" },
    { "vuki656/package-info.nvim", opts = {}, event = "BufReadPre package.json" },

    { "nvim-tree/nvim-web-devicons", lazy = true },

    { "Bekaboo/dropbar.nvim" },
    { "j-hui/fidget.nvim", opts = {} },

    -- Functionality
    { "iamcco/markdown-preview.nvim", build = ":call mkdp#util#install()", ft = "markdown" },
    { "chomosuke/term-edit.nvim", opts = { prompt_end = "➜" }, event = "TermOpen" },
    { "ahonn/resize.vim" },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = { map_cr = true, ignored_next_char = "[%w%.%{%[%(%\"%']" },
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
    { "tpope/vim-dotenv" },
}
