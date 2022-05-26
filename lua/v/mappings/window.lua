----------------------------------------------------------------------------//
-- Navigation in across Window/Buffer/Tabpage/Quickfix
----------------------------------------------------------------------------//

v.set_keybindings({
    -- alt + shift + hjkl to resize windows 
    -- Note: different in macOS and Windows
    -- { 'n', '<S-M-J>', '2<C-w>-' },
    -- { 'n', '<S-M-K>', '2<C-w>+' },
    -- { 'n', '<S-A-H>', '2<C-w><' },
    -- { 'n', '<S-A-L>', '2<C-w>>' },

    -- open/switch windows
    { 'n', '<leader>h', '<C-w>s' },
    { 'n', '<leader>v', '<C-w>v' },
    -- Open a new file in current directory
    { 'n', '<leader>ne', [[ :e <C-R>=expand("%:p:h") . "/" <CR> ]], {silent = false} },
    { 'n', '<leader>ns', [[ :vsp <C-R>=expand("%:p:h") . "/" <CR> ]], {silent = false} },

    -- open/switch  tabs
    -- { 'n', '<leader>tn', '<cmd>tabedit %<CR>' },
    -- { 'n', '<leader>tc', '<cmd>tabclose<CR>' },
    -- { 'n', '<leader>to', '<cmd>tabonly<CR>' },
    -- { 'n', '<leader>tm', '<cmd>tabmove<Space>' },
    -- { 'n', ']t', '<cmd>tabprev %<CR>' },
    -- { 'n', '[t', '<cmd>tabnext %<CR>' },

    -- quickfix/loclist navigation (vim-unimpaired)
    {'n', ']q', '<cmd>cnext<CR>zz' },
    {'n', '[q', '<cmd>cprev<CR>zz' },
    {'n', ']l', '<cmd>lnext<CR>zz' },
    {'n', '[l', '<cmd>lprev<CR>zz' },


})