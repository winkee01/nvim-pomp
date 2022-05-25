----------------------------------------------------------------------------------
-- Commandline mappings
----------------------------------------------------------------------------------
-- https://github.com/tpope/vim-rsi/blob/master/plugin/rsi.vim
-- c-a / c-e everywhere - RSI.vim provides these
-- <C-A> allows you to insert all matches on the command line e.g. bd *.js <c-a>
-- will insert all matching files e.g. :bd a.js b.js c.js

v.set_keybindings({
    { 'c', '<c-x><c-a>', '<c-a>' },
    { 'c', '<C-a>', '<Home>' },
    { 'c', '<C-e>', '<End>' },
    { 'c', '<C-b>', '<Left>' },
    { 'c', '<C-d>', '<Del>' },
    { 'c', '<C-k>', [[<C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos() - 2]<CR>]] },
    
    -- move cursor one character backwards unless at the end of the command line
    { 'c', '<C-f>', [[getcmdpos() > strlen(getcmdline())? &cedit: "\<Lt>Right>"]], { expr = true } },
    
    -- see :h cmdline-editing
    { 'c', '<Esc>b', [[<S-Left>]] },
    { 'c', '<Esc>f', [[<S-Right>]] },
    
    -- Insert escaped '/' while inputting a search pattern
    -- { 'c', '/', [[getcmdtype() == "/" ? "\/" : "/"]], { expr = true } },

    -- smooth searching, allow tabbing between search results similar to using <c-g> or <c-t> 
    -- the main difference is: tab is easier to hit and remapping those keys to these would swallow up a tab mapping
    -- Caution: have some glitches, need to type <BS> to show
    -- How to fix? no idea
    -- Note: overriden by nvim-cmp's tab completion
    -- { 'c', '<Tab>', [[getcmdtype() == "/" || getcmdtype() == "?" ? "<CR>/<C-r>/" : "<Tab>"]], {expr = true} },
    -- { 'c', '<S-Tab>', [[getcmdtype() == "/" || getcmdtype() == "?" ? "<CR>?<C-r>/" : "<S-Tab>"]], {expr = true} },

    -- sudo
    { 'c', 'w!!', [[w !sudo tee % >/dev/null]] },
    -- insert path of current file into a command
    { 'c', '%%', "<C-r>=fnameescape(expand('%'))<cr>" },
})

