return {
    { "seblyng/nvim-ts-autotag", dev = true },
    { "seblyng/nvim-lsp-extras", dev = true },
    { "seblyng/git-conflict.nvim", dev = true },

    { "saecki/crates.nvim", opts = {}, event = "BufReadPre Cargo.toml" },
    { "vuki656/package-info.nvim", opts = {}, event = "BufReadPre package.json" },

    { "b0o/schemastore.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "brianhuster/unnest.nvim" },

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
