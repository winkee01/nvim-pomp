-- TODO: https://github.com/pwntester/octo.nvim

local M = {
    -- git CLI for command mode
    -- TODO: 
    -- something like this would be nice 
    -- https://www.reddit.com/r/neovim/comments/qatokl/using_nvim_as_mergetool_with_vimfugitive/
    {
        'tpope/vim-fugitive',
        requires = {
            'tpope/vim-rhubarb', -- integration with GitHub
            'tommcdo/vim-fubitive', -- integration with BitBucket
        },
        cmd = {
            'Git',
            'GBrowse',
            'Gdiff',
            'Gdiffsplit',
            'Gvdiffsplit',
        },
        keys = {
            '<leader>gd',
            '<leader>gh',
            '<leader>gl',
            '<leader>gg',
            '<Leader>ga',
            { 'v', '<leader>gg' },
        },
    },
    {
        'lewis6991/gitsigns.nvim',
        after = 'plenary.nvim',
        event = 'CursorHold',
    },
    {
        'sindrets/diffview.nvim',   -- git diff for modified files
        requires = 'nvim-lua/plenary.nvim',
        cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
        after = 'devicons',
    },
}

return M
