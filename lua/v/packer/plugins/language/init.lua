-- Language enhancement
local conf = v.conf_mod('language')

local M = {
    {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        -- config = conf('treesitter'),
        local_path = 'contributing',
    },
    { 'p00f/nvim-ts-rainbow', after = 'nvim-treesitter' }, -- colored matching brackets

    -- { 
    --     'David-Kunz/treesitter-unit', -- deal with treesitter units
    --     requires = 'nvim-treesitter/nvim-treesitter',
    --     after = 'nvim-treesitter',
    -- },
    -- { 'nvim-neorg/tree-sitter-norg' },
    { 
        'RRethy/nvim-treesitter-endwise',
        config = function()
            require('nvim-treesitter.configs').setup {
            endwise = {
                enable = true,
            },
        }
        end,
    },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    -- {
    --   'nvim-treesitter/playground',
    --   keys = '<leader>E',
    --   cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
    --   setup = function()
    --     v.map(
    --       '<leader>E',
    --       '<Cmd>TSHighlightCapturesUnderCursor<CR>',
    --       'treesitter: highlight cursor group'
    --     )
    --   end,
    -- },

    -- lua, JSON, ...
    { 'folke/lua-dev.nvim', requires = 'nvim-lua/plenary.nvim' }, -- see v/plugins-config/lsp/servers/sumneko_lua.lua
    { 'b0o/schemastore.nvim' }, -- JSON
    -- { 'bfredl/nvim-luadev' }

    -- web development
    {'vuki656/package-info.nvim', requires = 'MunifTanjim/nui.nvim'}, -- display npm package info
    -- TODO: emmet_ls
    -- TODO: https://pbs.twimg.com/media/FC6NKbQWEAA6ZLc?format=jpg&name=4096x4096
    {
        'mattn/emmet-vim',
        ft = {
            'html',
            'vue',
            'javascript.jsx',
            'typescript.tsx',
        },
    },
    { 
      'jose-elias-alvarez/nvim-lsp-ts-utils', 
      requires = 'nvim-lua/plenary.nvim',
    },
    { 'norcalli/nvim-colorizer.lua' },

    -- golang
    -- { 
    --     'ray-x/go.nvim', 
    --     -- require = 'hrsh7th/nvim-cmp',
    --     -- after = 'nvim-lspconfig',
    --     ft = 'go', 
    --     config = conf('go')
    -- },

    -- rust
    { "simrat39/rust-tools.nvim" },

    -- python
    { 'Vimjas/vim-python-pep8-indent', ft = { 'python' } }, -- indent follows the PEP8 style
    { 'jeetsukumaran/vim-pythonsense', ft = { 'python' } }, -- python text object
    -- {
    --     'GCBallesteros/jupytext.vim',
    --     config = function() conf('jupytext') end
    -- }

    { 'lervag/vimtex', ft = { 'tex', 'plaintex' } }, -- LaTeX
    { 'editorconfig/editorconfig-vim' }, -- .editorconfig files
    -- { 'fladson/vim-kitty', ft = { 'kitty' } }, -- kitty config

    -- Docs generation
    -- { 'kkoomen/vim-doge' },  -- Generate doc for different languages
    {
        'heavenshell/vim-jsdoc',
        cmd = { 'JsDoc', 'JsDocFormat' },
        keys = '<Leader>j',
        run = 'make install',
        as = 'jsdoc'
    },
    { 'milisims/nvim-luaref', ft = 'lua' }, -- lua documentation in :help

    -- Spell
    { 
        'psliwka/vim-dirtytalk',  -- spellcheck dictionary for programmers
        run = ':DirtytalkUpdate', 
        config = function() 
            vim.opt.spelllang:append('programming') 
        end 
    },
    -- {
    --   'lewis6991/spellsitter.nvim',
    --   config = function()
    --     require('spellsitter').setup({ enable = true })
    --   end,
    -- },
    -- markdown previewer in browser
    -- DEPENDENCY: npm
    {
        'iamcco/markdown-preview.nvim',
        ft = 'markdown',
        run = 'cd app && npm install',
    },
    { 'dkarter/bullets.vim', ft = 'markdown' }, -- markdown lists
    {
        'dhruvasagar/vim-table-mode',
        ft = {'markdown'},
        -- NOTE: Setup to run before
        -- setup = conf('vim-table-mode'),
        config = conf('vim-table-mode')
    },

    { 'mboughaba/i3config.vim', ft = 'i3config' }, -- i3wm cofig file
    
    {
      'folke/todo-comments.nvim', -- Highlight TODO keyword in comments
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        -- this plugin is not safe to reload
        if vim.g.packer_compiled_loaded then
          return
        end
        require('todo-comments').setup({
          highlight = {
            exclude = { 'org', 'orgagenda', 'vimwiki', 'markdown' },
          },
        })
        -- v.map('n', '<leader>lt', [[ vim.cmd('TodoTrouble') ]])
      end,
    },

    {
        'itchyny/vim-highlighturl',
        event = {
            'CursorHold',
            'CursorMoved',
        },
    },

    -- better treesitter highlithing in angular
    {
        'nvim-treesitter/nvim-treesitter-angular',
        ft = {
            'typescript',
            'javascript',
            'html',
        },
        after = 'nvim-treesitter',
    },

    -- JSON
    -- TODO: can this work with treesitter and LSP?
    {
        'elzr/vim-json',
        disable = true,
        ft = {
            'json',
            'jsonc',
            'jsonp',
        },
    },

    -- {
    --   'akinsho/flutter-tools.nvim',
    --   requires = { 'mfussenegger/nvim-dap', 'plenary.nvim' },
    --   -- local_path = 'personal',
    --   config = conf('flutter-tools'),
    -- },

    -- { 'dart-lang/dart-vim-plugin' }
    { 'mtdl9/vim-log-highlighting' },

    -- better commentstrings based in treesitter
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        as = 'context-commentstring',
        -- after = { 'vim-commentary', 'nvim-treesitter' },
    },

    -- autoclose and autoedit html tags
    {
        'windwp/nvim-ts-autotag',
        ft = {
            'html',
            'vue',
            'javascript.jsx',
            'javascriptreact',
            'typescript.tsx',
            'typescriptreact',
            'markdown',
        },
    },

    -- fix `gf` for some filetypes
    -- {
    --     'tpope/vim-apathy',
    --     ft = {
    --         'go',
    --         'javascript',
    --         'typescript',
    --         'lua',
    --         'python',
    --         'c',
    --         'cpp',
    --     },
    -- },
    {
        'danymat/neogen', -- Create annotations
        keys = { '<localleader>nc' },
        requires = {
            'nvim-treesitter/nvim-treesitter',
            -- 'saadparwaiz1/cmp_luasnip',
        },
        module = 'neogen',
        setup = function()
            v.map('n', '<localleader>nc', [[ :call v:lua.require('neogen').generate ]])
        end,
        config = function()
            require('neogen').setup({ snippet_engine = 'luasnip' })
        end,
    },

    -- { 'JuliaEditorSupport/julia-vim'}

    {
        'chrisbra/csv.vim',
        ft = {'csv'}
    }

    -- Org mode
    -- {
    --   'vhyrro/neorg',
    --   requires = { 'vhyrro/neorg-telescope', 'max397574/neorg-kanban' },
    --   config = conf('neorg'),
    -- },
    -- {
    --   'nvim-orgmode/orgmode', 
    --   config = function()
    --     require('orgmode').setup{}
    --   end
    -- }
    -- {
    --   'lukas-reineke/headlines.nvim', -- add background for markdown, vimwiki, or orgmode files
    --   setup = conf('headlines').setup,
    --   config = conf('headlines').config,
    -- },
}

return M
