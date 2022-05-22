require('v.utils.mappings').set_keybindings {
    -- ###### 2. Switch Between Windows######
    { "n", "˙", "<C-w>h" }, -- Alt h to left window
    { "n", "¬", "<C-w>l" }, -- Alt l to right window
    { "n", "∆", "<C-w>j" }, -- Alt j to above window
    { "n", "˚", "<C-w>k" }, -- Alt k to below window

    -- ###### 3. Move cursor in INSERT mode ######
    -- ^^^^ (1) Move cursor by one char (macOS: Option key as Normal key)
    { 'i', '≤', '<Home>' },    -- Alt , move cursor to line begin
    { 'i', '…', '<End>' },     -- Alt ; move cursor to line end

    -- ###### 4. Move line up/down ######
    -- ====== macOS: Option key as Normal key
    -- Alt j move down
    -- Alt k move up
    -- Note 1): due to vim's bugs, this may behave abnormally
    -- Note 2): tpope/vim-unimpaired also has [e and ]e to move line up/down
    -- { "n", "∆", ":m .+1<CR>gv==gv" } -- conflice with switching window
    -- { "n", "˚", ":m .-2<CR>gv==gv" } -- conflice with switching window
    { "i", "∆", '<Esc>:m+<CR>==gi' },
    { "i", "˚", '<Esc>:m-2<CR>==gi' },
    { "v", "∆", ":m '>+1<CR>gv=gv" },
    { "v", "˚", ":m '<-2<CR>gv=gv" },


    -- ###### 5. Jump between change list ######
    -- ====== Mac OSX: Option key as Meta ======
    -- Change list
    -- Alt - move cursor to previous change
    -- Alt + move cursor to next change
    { "i", "–", "g;" },
    { "i", "≠", "g," },

    -- ###### 6. Resize windows ######
    -- Note: Only works in macOS (meta as normal)
    -- (alt + shift + hjkl) 
    { 'n', '', '2<C-w>-' }, -- Alt+Shift+k
    { 'n', 'Ô', '2<C-w>+' }, -- Alt+Shift+j
    { 'n', 'Ò', '2<C-w><' }, -- Alt+Shift+l
    { 'n', 'Ó', '2<C-w>>' }, -- Alt+Shift+h
}