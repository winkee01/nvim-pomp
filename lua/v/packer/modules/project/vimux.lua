local cmd = vim.api.nvim_command

v.set_viml_options('Vimux', {
    Orientation = 'h', -- open tmux panes as vertical splits
    CloseOnExit = false, -- close pane after exiting vim
})

-- TODO: ??
cmd('command VimuxClearScreenHistory VimuxClearTerminalScreen | VimuxClearRunnerHistory')

v.set_keybindings({
    { 'n', '<Leader>tp', '<cmd>VimuxPromptCommand<CR>' },
    { 'n', '<Leader>tr', '<cmd>VimuxRunLastCommand<CR>' },
    { 'n', '<Leader>ti', '<cmd>VimuxInspectRunner<CR>' },
    { 'n', '<Leader>tz', '<cmd>VimuxZoomRunner<CR>' },
    { 'n', '<Leader>tc', '<cmd>VimuxClearScreenHistory<CR>' },
    { 'n', '<Leader>tt', '<cmd>VimuxTogglePane<CR>' },
})
