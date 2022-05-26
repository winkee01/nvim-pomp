v.set_keybindings {
    -- ###### 2. Switch Between Windows######
    { "n", "<A-h>", "<C-w>h" }, -- Alt h to left window
    { "n", "<A-l>", "<C-w>l" }, -- Alt l to right window
    { "n", "<A-j>", "<C-w>j" }, -- Alt j to above window
    { "n", "<A-k>", "<C-w>k" }, -- Alt k to below window

    -- ###### 3. Move cursor in INSERT mode ######
    -- ^^^^ (2) Move cursor to the line begin/end
    -- Alt , move cursor to line begin
    -- Alt ; move cursor to line end
    { "i", "<A-,>", "<ESC>I" },
    { "i", "<A-;>", "<ESC>A" },

    -- ###### 4. Move current line up/down ######
    -- Alt j move down
    -- Alt k move up
    -- Note 1): due to vim's bugs, this may behave abnormally
    -- Note 2): tpope/vim-unimpaired also has [e and ]e to move line up/down
    -- map("n", "<A-j>", ":m .+1<CR>gv==gv", opt) -- conflice with switching window
    -- map("n", "<A-k>, ":m .-2<CR>gv==gv", opt) -- conflice with switching window
    { "i", "<A-j>", "<Esc>:m .+1<CR>gv==gvi" },
    { "i", "<A-k>", "<Esc>:m .-2<CR>gv==gvi" },
    { "v", "<A-j>", ":m '>+1<CR>gv=gv" },
    { "v", "<A-k>", ":m '<-2<CR>gv=gv" },

    -- ###### 5. Jump between change list ######
    -- Change list
    -- Alt - move cursor to previous change
    -- Alt + move cursor to next change
    { "i", "<A-->", "g;" },
    { "i", "<A-+>", "g," },

        -- ###### 6. Resize windows ######
    -- Note: Only works in macOS (meta as normal)
    -- (alt + shift + hjkl) 
    { 'n', '<S-M-K>', '2<C-w>-' }, -- Alt+Shift+k
    { 'n', '<S-M-J>', '2<C-w>+' }, -- Alt+Shift+j
    { 'n', '<S-A-L>', '2<C-w><' }, -- Alt+Shift+l
    { 'n', '<S-A-H>', '2<C-w>>' }, -- Alt+Shift+h
}