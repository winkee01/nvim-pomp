local M = {
    { 'kyazdani42/nvim-web-devicons', as = 'devicons' }, -- colored icons
    { 'p00f/nvim-ts-rainbow', after = 'nvim-treesitter' }, -- colored matching brackets
    {
        'SmiteshP/nvim-gps',    -- show cursor context in statusline
        requires = 'nvim-treesitter/nvim-treesitter',
        config = function()
          require('nvim-gps').setup({})
        end,
        -- disable = true,
    },
    {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = v.conf('treesitter'),
      local_path = 'contributing',
    },
    { 'b0o/incline.nvim', config = v.conf('incline') },
    -- indent lines
    {
        'lukas-reineke/indent-blankline.nvim',
        after = 'nvim-treesitter',
    },

    -- colorcolumn with virtual text
    {
        'lukas-reineke/virt-column.nvim',
        disable = true,
        event = {
            'CursorHold',
            'CursorMoved',
        },
    },
}

return M