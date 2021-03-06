-- TODO: solve VimLeave errors

v.set_viml_options('gutentags', {
    cache_dir = os.getenv('HOME') .. '/.cache/tags', -- don't pollute my project
    plus_nomap = true, -- don't pollute my mappings
})

v.set_keybindings({
    { 'n', '<leader>gr', ':GscopeFind s <C-R><C-W><cr>' },
    { 'n', '<leader>gd', ':GscopeFind g <C-R><C-W><cr>' },
})
