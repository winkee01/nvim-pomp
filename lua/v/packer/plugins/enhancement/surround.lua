-- ## vim-surround
-- local g = vim.g

-- g.surround_no_mappings = true
-- g.surround_no_insert_mappings = true

-- v.set_keybindings({
--     { 'n', 'ds',  '<Plug>Dsurround'  },
--     { 'n', 'cs',  '<Plug>Csurround'  },
--     { 'n', 'cS',  '<Plug>CSurround'  },
--     { 'n', 'xs',  '<Plug>Ysurround'  },
--     { 'n', 'xS',  '<Plug>YSurround'  },
--     { 'n', 'xss', '<Plug>Yssurround' },
--     { 'n', 'xSs', '<Plug>YSsurround' },
--     { 'n', 'xSS', '<Plug>YSsurround' },
--     { 'x', 'S',   '<Plug>VSurround'  },
--     { 'x', 'gS',  '<Plug>VgSurround' },
-- })


-- surround.nvim
-- Originally from blackCauldron7/surround.nvim
require("surround").setup {
    context_offset = 100,
    load_autogroups = false,
    mappings_style = "sandwich",
    map_insert_mode = true,
    quotes = {"'", '"'},
    brackets = {"(", '{', '['},
    space_on_closing_char = false,
    pairs = {
        nestable = { b = { "(", ")" }, s = { "[", "]" }, B = { "{", "}" }, a = { "<", ">" } },
        linear = { q = { "'", "'" }, t = { "`", "`" }, d = { '"', '"' }}
    },
    prefix = "s"
}
