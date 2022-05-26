
-- ###### 7. Clipboard mappings ######
-- Note: Use these mapping conservatively because they may conflict with default behavior in vim
-- Ctrl+C copy
-- Ctrl+V paste
-- Ctrl+S save
-- Ctrl+Q exit
-- Ctrl+A select all
-- Ctrl+F search
-- Ctrl+Z undo
-- Ctrl+Y redo

v.set_keybindings({
    {'v', '<C-c>', '"+y'},
    {'v', '<C-v>', '"+p'},
    -- {'v', '<C-x>', '"+c'},  -- conflict with ctrl-v in normal mode
    -- {'n', '<C-v>', '"+gP'}, -- conflict with ctrl-v in visual mode
    -- {'i', '<C-v>', '<C-r><C-o>"'},
    {'i', '<C-s>', '<ESC>:up<CR>'},
    {'n', '<C-s>', ':up<CR>'},
    {'n', '<C-a>', 'ggVG<CR>'},
    -- {'i', '<C-a>', '<ESC>ggVG<CR>i'},  -- conflict with default <c-a> in insert mode
    -- {'i', '<C-f>', '<ESC>/'},   -- conflict with Telescope
    -- {'i', '<C-f>', '/'},    -- conflict with Telescope

    -- Yank filename to clipboard
    {'n', '<leader>cl', [[:let @+=expand("%:p")<CR>]]},
}, {noremap = true, silent = false})