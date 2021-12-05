local augroup = require('seblj.utils').augroup
local nnoremap = vim.keymap.nnoremap

local plugin_dir = '~/projects/plugins/'

augroup('CompilePacker', {
    event = 'BufWritePost',
    pattern = 'plugins.lua',
    command = function()
        vim.cmd('PackerCompile')
    end,
})

return require('packer').startup({
    function(use)
        use({ 'wbthomason/packer.nvim' }) -- Package manager

        -- Uses local plugin if exists. Install from github if not
        -- Idea from https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/plugins.lua.
        -- Extend this from tj to allow options
        local local_use = function(first)
            local opts = {}
            local plugin = first
            if type(first) == 'table' then
                plugin = vim.tbl_flatten(first)[1]
                -- Get all the options
                for k, v in pairs(first) do
                    if type(k) ~= 'number' and k ~= 'upstream' then
                        opts[k] = v
                    end
                end
            end
            local plugin_list = vim.split(plugin, '/')
            local username = plugin_list[1]
            local plugin_name = plugin_list[2]

            local use_tbl = {}
            if vim.fn.isdirectory(vim.fn.expand(plugin_dir .. plugin_name)) == 1 and first['upstream'] ~= true then
                table.insert(use_tbl, plugin_dir .. plugin_name)
            else
                if first['force_local'] then
                    return
                end
                table.insert(use_tbl, string.format('%s/%s', username, plugin_name))
            end

            use(vim.tbl_extend('error', use_tbl, opts))
        end

        -- My plugins/forks
        local_use({
            'seblj/nvim-tabline', -- Tabline
            config = function()
                require('tabline').setup({})
            end,
            event = 'TabNew',
        })
        local_use({
            'seblj/nvim-echo-diagnostics', -- Echo lspconfig diagnostics
            config = function()
                require('echo-diagnostics').setup({})
            end,
            after = 'nvim-lspconfig',
            disable = Use_coc,
        })
        local_use({
            'seblj/nvim-xamarin', -- Build Xamarin from Neovim
            config = function()
                require('xamarin').setup({})
            end,
            force_local = true,
            disable = true,
        })

        use({ 'lewis6991/impatient.nvim' })

        -- Installed plugins
        -- Colors / UI
        use({
            'norcalli/nvim-colorizer.lua', -- Color highlighter
            config = function()
                require('colorizer').setup()
            end,
        })
        use({
            'mhinz/vim-startify', -- Startup screen
            config = function()
                require('config.startify')
            end,
        })
        use({
            'glepnir/galaxyline.nvim', -- Statusline
            config = function()
                require('config.galaxyline')
            end,
        })
        use('kyazdani42/nvim-web-devicons') -- Icons

        -- Git
        use({
            'pwntester/octo.nvim',
            config = function()
                require('octo').setup()
            end,
        })
        use({
            'lewis6991/gitsigns.nvim', -- Git diff signs
            event = { 'BufReadPre', 'BufWritePre' },
            config = function()
                require('config.gitsigns')
            end,
        })
        use({
            'rhysd/conflict-marker.vim', -- Highlights for git conflict
            config = function()
                vim.g.conflict_marker_begin = '^<<<<<<< .*$'
                vim.g.conflict_marker_end = '^>>>>>>> .*$'
                vim.g.conflict_marker_enable_mappings = 0
            end,
            event = 'BufReadPre',
        })

        use({
            'sindrets/diffview.nvim',
            config = function()
                require('config.diffview')
            end,
        })

        use({
            'github/copilot.vim',
            cmd = 'Copilot',
        })

        -- Treesitter
        use({
            'nvim-treesitter/nvim-treesitter', -- Parser tool syntax
            run = function()
                -- Post install hook to ensure maintained installed instead of in config
                -- Don't need to waste startuptime on ensuring installed on every start
                require('nvim-treesitter.install').ensure_installed('maintained')
                vim.cmd('TSUpdate')
            end,
            config = function()
                require('config.treesitter')
            end,
            requires = {
                'nvim-treesitter/playground', -- Display information from treesitter
                'windwp/nvim-ts-autotag', -- Autotag using treesitter
                'nvim-treesitter/nvim-treesitter-textobjects', -- Manipulate text using treesitter
                'JoosepAlviste/nvim-ts-context-commentstring', -- Auto switch commentstring with treesitter
                -- {
                --     'lewis6991/spellsitter.nvim',
                --     config = function()
                --         require('spellsitter').setup({
                --             enable = { 'tex' },
                --         })
                --     end,
                -- },
            },
        })

        -- LSP
        use({
            'neovim/nvim-lspconfig', -- Built-in LSP
            config = function()
                require('config.lspconfig')
            end,
            requires = 'folke/lua-dev.nvim',
        })
        use({
            'jose-elias-alvarez/null-ls.nvim',
            disable = Use_coc,
        })
        use({
            'L3MON4D3/LuaSnip',
            config = function()
                require('config.luasnip')
            end,
        })
        use({
            'hrsh7th/nvim-cmp', -- Completion
            config = function()
                require('config.cmp')
            end,
            requires = {
                { 'hrsh7th/cmp-nvim-lsp' },
                { 'hrsh7th/cmp-buffer' },
                { 'hrsh7th/cmp-path' },
                { 'saadparwaiz1/cmp_luasnip' },
            },
        })
        use({ 'onsails/lspkind-nvim' }) -- Icons for completion


        -- use({ 'tjdevries/sg.nvim' })
        use({
            'ThePrimeagen/refactoring.nvim',
            config = function()
                require('config.refactoring')
            end,
            keys = '<leader>fr',
        })
        use({
            'ThePrimeagen/harpoon',
            config = function()
                require('config.harpoon')
            end,
        })

        -- Telescope
        use({
            'nvim-telescope/telescope.nvim', -- Fuzzy finder
            requires = {
                { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
                { 'nvim-lua/plenary.nvim' },
            },
            config = function()
                require('config.telescope')
            end,
        })

        use({
            'mfussenegger/nvim-dap', -- Debugger
            config = function()
                require('config.dap')
            end,
            requires = 'rcarriga/nvim-dap-ui',
            keys = '<leader>db',
        })
        use({
            'szw/vim-maximizer', -- Maximize split
            config = nnoremap({ '<leader>m', ':MaximizerToggle!<CR>' }),
        })

        use({
            'vim-test/vim-test', -- Testing
            config = function()
                require('config.test')
            end,
            cmd = { 'TestFile', 'TestNearest', 'TestLast' },
            requires = {
                {
                    'rcarriga/vim-ultest', -- Testing UI
                    run = ':UpdateRemotePlugins',
                    cond = function()
                        return false
                    end,
                },
            },
        })

        use({
            'kyazdani42/nvim-tree.lua', -- Filetree
            config = function()
                require('config.luatree')
            end,
            cmd = { 'NvimTreeToggle', 'NvimTreeOpen' },
            keys = { '<leader>tt' },
        })
        use({
            'tamago324/lir.nvim', -- File explorer
            config = function()
                require('config.fileexplorer')
            end,
        })

        use({ 'lambdalisue/suda.vim' }) -- Write with sudo
        use({ 'tpope/vim-commentary' }) -- Easy commenting
        use({ 'tpope/vim-scriptease' }) -- Great commands
        use({ 'wellle/targets.vim' })
        -- use({
        --     'numToStr/Comment.nvim',
        --     config = function()
        --         require('Comment').setup()
        --     end,
        -- })
        use({
            'dstein64/vim-startuptime', -- Measure startuptime
            config = function()
                vim.g.startuptime_more_info_key_seq = 'i'
                vim.g.startuptime_split_edit_key_seq = ''
            end,
            cmd = 'StartupTime',
        })
        use({
            'windwp/nvim-autopairs', -- Auto pairs
            config = function()
                require('config.autopairs')
            end,
            -- event = 'InsertEnter',
        })
        use('tpope/vim-surround') -- Edit surrounds
        use({
            'godlygeek/tabular',
            config = function()
                vim.g.no_default_tabular_maps = 1
            end,
        }) -- Line up text
        use({
            'vuki656/package-info.nvim',
            requires = 'MunifTanjim/nui.nvim',
            config = function()
                require('config.packageinfo')
            end,
            ft = 'json',
        })
        use({
            'rcarriga/nvim-notify',
            config = function()
                vim.notify = require('notify')
                require('notify').setup({
                    on_open = function(win)
                        -- Don't like when it shows after packer sync and blocks the
                        -- commits from plugins. So print normal if ft is packer
                        local ft = vim.api.nvim_buf_get_option(0, 'ft')
                        if ft == 'packer' then
                            vim.api.nvim_win_close(win, true)
                            local history = require('notify').history()
                            local last = history[#history]
                            print(unpack(last.message))
                        end
                    end,
                })
            end,
        })
        use('tpope/vim-repeat') -- Reapat custom commands with .
        use({
            'lervag/vimtex', -- Latex
            config = function()
                require('config.vimtex')
            end,
            ft = { 'tex', 'bib' },
        })
        use({ 'NTBBloodbath/rest.nvim', ft = 'http' }) -- HTTP requests
        use({
            'iamcco/markdown-preview.nvim', -- Markdown preview
            run = 'cd app && yarn install',
            ft = 'markdown',
        })
        use({ 'mbbill/undotree', cmd = 'UndotreeToggle' })
    end,
    config = {
        profile = {
            enable = true,
        },
        display = {
            prompt_border = 'rounded',
        },
    },
})
