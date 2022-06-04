require('lightspeed').setup({
    jump_on_partial_input_safety_timeout = 400,
    highlight_unique_chars = true, -- gets slow if lots of content
    grey_out_search_area = true,
    match_only_the_start_of_same_char_seqs = true,
    limit_ft_matches = 5,
    -- x_mode_prefix_key = '<c-x>',
    substitute_chars = {},
    instant_repeat_fwd_key = nil,
    instant_repeat_bwd_key = nil,
    labels = nil,
    cycle_group_fwd_key = nil,
    cycle_group_bwd_key = nil,
})

v.map('n', '<C-s>', '<Plug>Lightspeed_s')

-- I used to use <C-M-S>, but then I learned to config
-- Kitty to correctly expose ctrl + shift + s as <C-S-s>
v.map('n', '<C-S-s>', '<Plug>Lightspeed_S')


-- map( { "x", "n", "o" }, '<leader>j', '<Plug>Lightspeed_S', { noremap = false })
-- map( { "x", "n", "o" }, '<leader>k', '<Plug>Lightspeed_S', { noremap = false })
