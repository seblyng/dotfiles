return {
    { "seblyng/nvim-ts-autotag", dev = true },

    { "github/copilot.vim" },

    { "seblyng/git-conflict.nvim", dev = true },

    { "saecki/crates.nvim", opts = {}, event = "BufReadPre Cargo.toml" },
    { "vuki656/package-info.nvim", opts = {}, event = "BufReadPre package.json" },

    { "nvim-tree/nvim-web-devicons" },

    { "Bekaboo/dropbar.nvim" },
    { "j-hui/fidget.nvim", opts = {} },
    { "chomosuke/term-edit.nvim", opts = { prompt_end = "➜" }, event = "TermOpen" },
    { "lambdalisue/vim-suda" },

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
