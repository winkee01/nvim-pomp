local conf = v.conf_mod('appearance')

local M = {
    { 'kyazdani42/nvim-web-devicons', as = 'devicons'}, -- colored icons
    {
        'SmiteshP/nvim-gps',    -- show cursor context in statusline
        requires = 'nvim-treesitter/nvim-treesitter',
        after = 'nvim-treesitter',
        config = conf('gps'),
        -- config = function()
        --     require('nvim-gps').setup({
        --     icons = {
        --         ['class-name']     = 'ﴯ ',
        --         ['function-name']  = ' ',
        --         ['method-name']    = ' ',
        --         ['container-name'] = '⛶ ',
        --     },
        --     languages = {
        --         html = false,
        --     },
        --     separator = ' > ',
        -- })
        -- end,
    },
    
    { 'b0o/incline.nvim', config = conf('incline')},
    {
        'lukas-reineke/indent-blankline.nvim',
        after = 'nvim-treesitter',
        config = conf('indent-blankline'),
    },
    {
        'lukas-reineke/virt-column.nvim',  -- use a char to display colorcolumn
        disable = true,
        event = {
            'CursorHold',
            'CursorMoved',
        },
        config = conf('virt-column')
    },
    { 'rcarriga/nvim-notify' }, -- beautiful notifications
    { 'kwkarlwang/bufresize.nvim' }, -- preserve window sizes on terminal resize
    -- {
    --   'simeji/winresizer', -- resize mode
    --   setup = function()
    --     vim.g.winresizer_start_key = '<leader>wr'
    --   end,
    -- },

    { 'crispgm/nvim-tabline' }, -- display opened tabs (2+)
    { 'stevearc/dressing.nvim', after = 'telescope.nvim', config = conf('dressing') }, -- improve vim.ui

    -- Make Color Code display color
    -- DEPENDENCY: Golang
    {
        'RRethy/vim-hexokinase',
        event = 'CursorHold',
        run = 'make hexokinase',
    },

    -- Status Line
    {
        'nvim-lualine/lualine.nvim',
        after = { 'devicons' },
        -- local_path = 'personal',
        config = conf('lualine'),
    },
    -- {
    --   'winkee01/galaxyline.nvim',
    --   -- requires = 'SmiteshP/nvim-gps',
    --   config = conf('galaxyline'),
    --   diable = true,
    -- },
    {
      'lewis6991/satellite.nvim', -- displays decorated scrollbars.
      config = conf('satellite'),
      -- config = function()
      --   require('satellite').setup()
      -- end,
    }
}

return M