local conf = v.conf_ex('appearance')

local M = {
    { 'kyazdani42/nvim-web-devicons', as = 'devicons'}, -- colored icons
    { 'p00f/nvim-ts-rainbow', after = 'nvim-treesitter' }, -- colored matching brackets
    {
        'SmiteshP/nvim-gps',    -- show cursor context in statusline
        requires = 'nvim-treesitter/nvim-treesitter',
        config = conf('gps'),
    },
    
    { 'b0o/incline.nvim', config = conf('incline')},
    {
        'lukas-reineke/indent-blankline.nvim',
        after = 'nvim-treesitter',
        -- config = conf('indent-blankline'),
    },
    {
        'lukas-reineke/virt-column.nvim',  -- use a char to display colorcolumn
        disable = true,
        event = {
            'CursorHold',
            'CursorMoved',
        },
        config = v.conf_ex_f('appearance')('virt-column')
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
    { 'stevearc/dressing.nvim' }, -- improve vim.ui
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
    },

}

return M