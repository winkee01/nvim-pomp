vim.g.mapleader = ','  -- default: \
vim.g.maplocalleader = ','

v.set_keybindings({
    {'n', '<Leader>q', ':q<CR>'},
    {'n', '<Leader>w', ':w<CR>'},
    {'n', '<Leader>z', ':wq<CR>'},
    {'n', '<Leader>wQ', ':qa<CR>'},
    {'n', '<Leader>Q', ':qa<CR>'},
    {'n', '<Leader>b', ':ls<CR>:b<Space>'},

    -- ^^^^^^ Change window size: left & right ^^^^^^
    {'n', '<C-Left>', ':vertical resize +2<CR>'},
    {'n', '<C-Right>', ':vertical resize -2<CR>'},
    -- ^^^^^^ Change window size: top & bottom ^^^^^^
    {'n', '<C-Down>', ':resize +2<CR>'},
    {'n', '<C-Up>', ':resize -2<CR>'},

    -- ###### 2. Switch Between Windows######
    -- ^^^^^^ Windows/Linux Only ^^^^^^

    -- ###### 3. Move cursor in INSERT mode ######
    -- $$$$ Different in windows/linux and macOS
    -- ^^^^ (1) Move cursor by one char
    { 'i', '<C-l>', '<Right>' },
    -- ^^^^ (2) Move cursor by one word
    { 'i', '<C-f>', '<ESC>ea' },
    { 'i', '<C-b>', '<C-Left>' },
    -- ^^^^ (3) Move cursor to the line begin/end
    -- ^^^^ (4) Continue editing in a new line
    -- new line above or below in insert mode
    { 'i', 'æ', '<ESC>o' },      -- Pressing <A-'> to open a new line in below
    { 'i', '<C-CR>', '<C-O>o' },
    { 'i', '<S-CR>', '<C-O>O' },
    -- get blank new line
    { 'n', '<Leader>o', 'o<Esc>^Da' },
    { 'n', '<Leader>O', 'O<Esc>^Da' },

    -- ^^^^ (5) Move line up/down
    -- {'v', 'J', ":move '>+1<CR>gv-gv"},
    -- {'v', 'K', ":move '<-2<CR>gv-gv"},
    { "n", "<C-Up>", ":m-2<CR> " },
    { "n", "<C-Down>", ":m+1<CR>" },

    -- ^^^^ (6) Scroll up/down
    {'n', '<C-u>', '9k'},
    {'n', '<C-d>', '9j'},

    -- ###### 4. Don't yank
    -- ^^^^ (1) Don't yank on delete char
    { "n", "x", '"_x' },
    { "n", "X", '"_X' },
    { "v", "x", '"_x' },
    { "v", "X", '"_X' },

    -- ^^^^ (2) Don't yank on visual paste
    { 'v', 'p', '"_dP' },

    -- ^^^^ (3) Select/Yank the whole line without line break
    -- vil/yil
    { 'x', 'il', '^og_' },
    { 'o', 'il', ':normal vil<CR>' },

    -- ###### 5. Change word around =
    -- c= change around =
    -- c: change around :
    -- c. change around .
    -- 2wC
    { 'o', '=', ':normal! f=wve<CR>' },
    { 'o', '+', ':normal! f=wvE<CR>' },
    { 'o', ';;', ':normal! f:wve<CR>' },
    { 'o', ':', ':normal! f:wvE<CR>' },
    { 'o', '.', ':normal! f.wve<CR>' },
    { 'o', ',', ':normal! f.wvE<CR>' },

    -- ###### 6. Undo break points ######
    { 'i', ',', ',<c-g>u'},
    { 'i', '.', '.<c-g>u'},
    { 'i', '-', '-<c-g>u'},
    { 'i', ':', ':<c-g>u'},
    { 'i', '(', '(<c-g>u'},
    { 'i', ')', ')<c-g>u'},
    { 'i', '{', '{<c-g>u'},
    { 'i', '}', '}<c-g>u'},
    { 'i', '[', '[<c-g>u'},
    { 'i', ']', ']<c-g>u'},
    { 'i', '!', '!<c-g>u'},
    { 'i', '?', '?<c-g>u'},

    -- substitutes Esc by Ctrl+C in normal mode
    { 'n', '<C-c>', '<Esc>' },

    -- Terminal mappings
    -- { 't', 'jk', [[<C-\><C-n>]] },

    -- break line after/before current position
    { 'n', ']b', 'a<CR><Esc>k$' },
    { 'n', '[b', 'i<CR><Esc>k$' },

    -- delete word with alt + backspace
    { 'i', '<M-BS>', '<C-w>' },

    -- delete word with ctrl + backspace 
    -- it's actually ctrl + shift + alt + backspace, but I've remapped
    -- that to ctrl + backspace in Kitty
    { 'i', '<M-C-S-H>', '<C-w>' },

    -- indenting in visual mode
    -- maintains selection
    { 'v', '<', '<gv' },
    { 'v', '>', '>gv' },

    -- Select last pasted text
    { 'n', 'gp', '`[v`]' },
    { 'n', 'gP', '`[V`]' },

    -- hide highlights
    { 'n', '<Leader>n', '<CMD>noh<CR>' },

    -- back tabs in insert mode
    { 'i', '<S-TAB>', '<C-D>' },

    -- show last 40 messages (by Justinmk)
    { 'n', 'g>', '<cmd>set nomore<bar>40messages<bar>set more<CR>' },

    -- Fold focus: folds all others (functions), but open current
    { 'n', '<leader>z', 'zMzvzz' },
    -- Recursively open all folds within the current function
    { 'n', 'z0', 'zCzO' },

    -- gf in a vertical split
    { 'n', '<c-w>f', '<c-w>vgf' },

    -- rerun the last command
    { 'n', '<leader><leader>c', ':<up><cr>' },

    -- FIXME: how to not get delay?
    -- insert escaped '/' while inputting a search pattern (by akisho)
    -- { 'c', '/', [[getcmdtype() == "/" ? "\\/" : "/"]], { expr = true } },
})

-- Resize window
-- if vim.fn.bufwinnr(1) then
--   vim.cmd('nmap <c-h> <C-W><')
--   vim.cmd('nmap <c-l> <C-W>>')
-- end

