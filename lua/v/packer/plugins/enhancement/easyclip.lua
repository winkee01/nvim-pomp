v.set_viml_options('EasyClip', {
    UseSubstituteDefaults = false,
    UseCutDefaults = false,
    AutoFormat = true,
})

v.set_keybindings({
    -- use s for substituting
    { 'n', 's', '<plug>SubstituteOverMotionMap' },
    { 'n', 'ss', '<plug>SubstituteLine' },
    { 'x', 's', '<plug>XEasyClipPaste' },
    { 'n', 'S', '<plug>SubstituteToEndOfLine' },

    -- use x for cutting
    { 'n', 'x', '<Plug>MoveMotionPlug' },
    { 'x', 'x', '<Plug>MoveMotionXPlug' },
    { 'n', 'xx', '<Plug>MoveMotionLinePlug' },
    { 'n', 'X', '<Plug>MoveMotionEndOfLinePlug' },

    -- toggle paste autoformat
    { 'n', '<leader>cf', '<plug>EasyClipToggleFormattedPaste' },

    -- paste in insert mode
    { 'i', '<c-v>', '<plug>EasyClipInsertModePaste' },

    -- navigate through the yank ring
    { 'n', ']p', '<Plug>EasyClipRotateYanksForward' },
    { 'n', '[p', '<Plug>EasyClipRotateYanksBackward' },
    { 'x', ']p', '<Plug>EasyClipRotateYanksForward' },
    { 'x', '[p', '<Plug>EasyClipRotateYanksBackward' },
})
