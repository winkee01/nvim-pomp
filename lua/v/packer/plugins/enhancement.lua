local conf = v.conf_ex('enhancement')

local M = {
    -- ## 0 ## misc
    -- { 'echasnovski/mini.nvim' },

    -- ## 1 ## Motion
    -- {
    --   'phaazon/hop.nvim',
    --   event = 'VimEnter',
    --   config = function()
    --     vim.defer_fn(function()
    --       return require('v.plugins-config.enhancement.hop')
    --     end, 2000)
    --   end,
    -- }
    {
        'ggandor/lightspeed.nvim',
        keys = { '<C-s>', '<C-S-s>' },
    },
    -- { 'chaoren/vim-wordmotion' }, -- problem with statusline mode display

    -- ## 2 ## View
    {
        'andymass/vim-matchup',  -- make % smarter
        event = {
            'CursorHold',
            'CursorMoved',
        },
        keys = {
            '%',
            'g%',
            '[%',
            ']%',
            'z%',
        },
    },
    {
      'declancm/cinnamon.nvim', -- NOTE: alternative: 'karb94/neoscroll.nvim'
      config = conf('cinnamon')
      -- config = function()
      --   require('cinnamon').setup({
      --     extra_keymaps = true,
      --     scroll_limit = 50,
      --   })
      -- end,
    },
    'lfv89/vim-interestingwords',  -- Highlight different words
    'AndrewRadev/linediff.vim',    -- Diff two blocks of code in a tmp buffer
    -- {"romainl/vim-cool", event = "VimEnter"},  -- Clear highlight search automatically

    -- Register & marks
    -- { 'junegunn/vim-peekaboo' }
    {
      'tversteeg/registers.nvim', 
      config = function() vim.g.registers_window_border = "single" end
    },
    { 'chentau/marks.nvim'},
    {
        'lucasvianav/vim-unimpaired', -- tpope/vim-unimpaired
        keys = {
            '[',
            ']',
            '<M-k>',
            '<M-j>',
            '<Space><Space>',
            'yo',
        },
    },
    -- pulse cursorline after search (easier to find the cursor)
    {
        'inside/vim-search-pulse',
        keys = {
            '/',
            '?',
            'n',
            'N',
            '*',
            '#',
        },
    },
    -- Align blocks of code
    -- { 'vim-tabular' }
    -- {
    --     'junegunn/vim-easy-align',
    --     cmd = 'EasyAlign',
    --     keys = '<Leader>a',
    -- },


    -- ## 3 ## Edit
    {
      'numToStr/Comment.nvim',
      requires = {
        {
          'JoosepAlviste/nvim-ts-context-commentstring',
          module = 'ts_context_commentstring',
        },
      },
    },
    { 'windwp/nvim-autopairs', event = 'InsertEnter' }, -- auto pairs for {[()]}
    -- { 'machakann/vim-swap', event = 'VimEnter' }, -- swap the position of two function arguments
    { 'mizlan/iswap.nvim', event = 'VimEnter' },
    { 'chrisbra/NrrwRgn', cmd = { 'NR', 'NUD' } }, -- Narrow region: Edit only on selected region
    {
        'AndrewRadev/splitjoin.vim',
        keys = { 'gS', 'gJ' },
        event = {
            'CursorHold',
            'CursorMoved',
        },
    },
    -- { 'max397574/better-escape.nvim', event = 'InsertEnter' }, -- better <Esc> with jk
    { 'tpope/vim-repeat', keys = '.', fn = 'repeat#set' }, -- enables . repeat for plugins
    -- Exchange two words/lines
    -- { 'mizlan/iswap.nvim' },
    {
        'tommcdo/vim-exchange',
        keys = {
            'cx',
            'cxx',
            'cxc',
            { 'v', 'X' },
        },
    },

    -- Surrounding  
    { 'ur4ltz/surround.nvim' },
    -- {
    --     'tpope/vim-surround',
    --     after = 'vim-repeat',
    --     event = { 'CursorMoved', 'CursorHold' },
    -- },

    -- Surround for functions
    -- { 'Matt-A-Bennett/vim-surround-funk', config = conf('surround-funk') }
    -- {
    --     'AndrewRadev/dsf.vim',
    --     after = 'vim-surround',
    --     keys = {
    --         'csf',
    --         'dsf',
    --         'dif',
    --         'daf',
    --         'dsnf',
    --         { 'o', 'if' },
    --         { 'o', 'af' },
    --     },
    -- },

    -- Word manipulation utilities
    -- {
    --     'tpope/vim-abolish',
    --     cmd = { 'Abolish', 'Subvert' },
    --     keys = 'cr',
    --     after = 'vim-repeat',
    -- },

    -- project-wide search and replace
    -- DEPENDENCY: RG, sed
    {
        'windwp/nvim-spectre',
        after = 'plenary.nvim',
        keys = {
            '<Leader>S',
            { 'v', '<Leader>S' },
        },
    },


    -- ## 4 ## Clipboard
    -- better clipboard
    -- https://github.com/AckslD/nvim-neoclip.lua
    -- https://github.com/bfredl/nvim-miniyank
    -- {
    --     'svermeulen/vim-easyclip',
    --     event = { 'CursorMoved', 'InsertEnter' },
    --     after = 'vim-repeat',
    -- },
    {
        'AckslD/nvim-neoclip.lua',
        require = { 'nvim-telescope/telescope.nvim' },
        event = { 'CursorMoved', 'InsertEnter' },
        after = 'vim-repeat',
    },
    {
      'kevinhwang91/nvim-hclipboard',
      event = 'InsertCharPre',
      config = function()
        require('hclipboard').start()
      end,
    },

    -- ## 5 ## Text Object
    {
        'wellle/targets.vim', -- provides great new text objects
        event = {
            'CursorHold',
            'CursorMoved',
        },
    },
    -- custom "indent block" text object
    {
        'kana/vim-textobj-indent',
        requires = { 'kana/vim-textobj-user' },
        event = 'CursorMoved',
    },

    -- ## 6 ## Utils
    -- { 'folke/which-key.nvim', event = 'CursorHold' }, -- displays a popup with keybindings
    -- use nvim in the browser
    {
        'glacambre/firenvim',
        run = function()
            vim.fn['firenvim#install'](0)
        end,
        disable = true, -- currently not working
    },

    { 'monaqa/dial.nvim' }, -- smartly increase/decrease a number or a date
    {
      'jghauser/fold-cycle.nvim',
      config = function()
        require('fold-cycle').setup({
            softwrap_movement_fix = false,
        })
        -- v.map('n', '<BS>', [[ :call require('fold-cycle').open() ]] )
      end,
    },
}

return M
