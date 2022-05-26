local conf = v.conf_ex('lsp')

local M = {
    { 'neovim/nvim-lspconfig', config = conf('lspconfig') },
    {
        'williamboman/nvim-lsp-installer',
        requires = { { 'neovim/nvim-lspconfig', config = conf('lspconfig') } },
        after = 'nvim-lspconfig',
        config = function()
          -- require('v.plugins-config.lsp.lsp.diagnostic') -- apply diagnostic configs
          v.augroup('LspInstallerConfig', {
            {
              event = 'Filetype',
              pattern = 'lsp-installer',
              command = function()
                vim.api.nvim_win_set_config(0, { border = v.style.current.border })
              end,
            },
          })
        end,
        -- config = conf('lsp-installer'),
    },
    -- { 'jose-elias-alvarez/typescript.nvim' },
    -- { 'RishabhRD/nvim-lsputils', after = 'nvim-lspconfig' },
    {
        'lukas-reineke/lsp-format.nvim',
        config = function()
            require('lsp-format').setup({
                go = { exclude = { 'gopls' } },
            })
            v.map('n', '<leader>rd', [[ vim.cmd('FormatToggle') ]])
        end,
    },

    -- {
    --     'jose-elias-alvarez/null-ls.nvim',
    --     requires = { 'nvim-lua/plenary.nvim' },
    --     config = conf('null-ls'),
    -- },

    { 'folke/lua-dev.nvim', ft = 'lua', as = 'lua-dev' }, -- setup LSP for lua-nvim dev
    { 'kosayoda/nvim-lightbulb', event = 'CursorHold' }, -- indicates code actions
    { 'nanotee/sqls.nvim', ft = 'sql' }, -- sql commands and code actions

    -- function signature
    {
        'ray-x/lsp_signature.nvim',
        event = 'CursorHold',
        after = 'nvim-lspconfig',
    },

    -- nice code actions
    {
        'weilbith/nvim-code-action-menu',
        key = '<leader>ca',
        disable = true,
    },

    -- code completion + lsp-like functionalities without actual lsp
    -- DEPENDENCY: universal-ctags, ctags
    {
        'ludovicchabant/vim-gutentags',
        requires = 'skywind3000/gutentags_plus',
        disable = true,
    },

    -- code completion
    {
        'hrsh7th/nvim-cmp',
        requires = {
            { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-lspconfig' },
            { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },         -- nvim-cmp source for nvim lua
            { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-calc', after = 'nvim-cmp' },             -- nvim-cmp source for math calculation.
            { 'f3fora/cmp-spell', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
            { 'uga-rosa/cmp-dictionary', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-emoji', after = 'nvim-cmp' },
            { 
                'saadparwaiz1/cmp_luasnip',   -- Snippet engine
                require = 'hrsh7th/nvim-cmp',
                after = 'nvim-cmp',
                event = { 'InsertEnter', 'CmdLineEnter' },
            },
            {
                'petertriho/cmp-git',
                after = 'nvim-cmp',
                config = function()
                  require('cmp_git').setup({ filetypes = { 'gitcommit', 'NeogitCommitMessage' } })
                end,
            },
            {
                'lukas-reineke/cmp-under-comparator',
                event = {
                    'CursorHold',
                    'CursorMoved',
                },
                after = 'nvim-cmp'
            },
            {
                'onsails/lspkind-nvim',
                event = {
                    'CursorHold',
                    'CursorMoved',
                },
            },
        },
        event = { 'InsertEnter', 'CmdLineEnter' },
    },
    {
        'L3MON4D3/LuaSnip', 
        require = {
            { 
                'saadparwaiz1/cmp_luasnip',  -- Snippet engine
                require = 'hrsh7th/nvim-cmp',
                event = { 'InsertEnter', 'CmdLineEnter' },
                after = 'nvim-cmp',
            }
        },
        event = { 'InsertEnter', 'CmdLineEnter' },
    },
    { 'rafamadriz/friendly-snippets'}, -- Snippets written in lua, needs LuaSnip or vsnip engine
    { 'honza/vim-snippets' }, -- Snippets written in snipmate syntax, needs Ultisnips or LuaSnip/vsnip
    { 'SirVer/ultisnips', event = 'InsertEnter' }, -- Snippet engine

    {
      'github/copilot.vim',
      config = function()
        vim.g.copilot_no_tab_map = true
        -- v.imap('<Plug>(as-copilot-accept)', "copilot#Accept('<Tab>')", { expr = true })
        -- v.inoremap('<M-]>', '<Plug>(copilot-next)')
        -- v.inoremap('<M-[>', '<Plug>(copilot-previous)')
        -- v.inoremap('<C-\\>', '<Cmd>vertical Copilot panel<CR>')

        vim.g.copilot_filetypes = {
          ['*'] = true,
          gitcommit = false,
          NeogitCommitMessage = false,
          DressingInput = false,
          TelescopePrompt = false,
          ['neo-tree-popup'] = false,
        }
        require('v.utils.highlights').set_hi_plugin('copilot', { CopilotSuggestion = { link = 'Comment' } })
      end,
    },

    -- pretty list for lsp
    {
        'folke/trouble.nvim',
        after = {
            'devicons',
            'nvim-lspconfig',
            'nvim-lspinstall',
        },
        cmd = 'Trouble',
        disable = true,
    },

    { 
        'ray-x/navigator.lua',
        requires = {
            { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' },
            { 'neovim/nvim-lspconfig' },
        },
    },
}

return M