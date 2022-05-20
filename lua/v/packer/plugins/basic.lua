local M = {
    -- use_local({ 'wbthomason/packer.nvim', local_path = 'contributing', opt = true }
    { 'wbthomason/packer.nvim', opt = true},

    -- TODO: doesn't work for some reason
    -- { 'nathom/filetype.nvim' }, -- faster filetype detection

    -- TODO: use {'lewis6991/impatient.nvim', rocks = 'mpack'}
    { 'lewis6991/impatient.nvim' }, -- improve startup time
    { 'antoinemadec/FixCursorHold.nvim' }, -- fixes CursorHold and CursorHoldl
    { 'nvim-lua/plenary.nvim' }, -- great utility lua functions
    { 'penlight', use = 'use_rocks'}
}

return M
