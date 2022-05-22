----------------------------------------------------------------------------//
-- Navigation in window
----------------------------------------------------------------------------//

require('v.utils.mappings').set_keybindings({
    -- Store relative line number jumps in the jumplist.
    {'n', 'j', [[(v:count > 1 ? 'm`' . v:count : '') . 'gj']], { expr = true, silent = true }},
    {'n', 'k', [[(v:count > 1 ? 'm`' . v:count : '') . 'gk']], { expr = true, silent = true }},

    -- Zero should go to the first non-blank character not to the first column (which could be blank)
    -- but if already at the first character then jump to the beginning
    --@see: https://github.com/yuki-yano/zero.nvim/blob/main/lua/zero.lua
    {'n', '0', "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", { expr = true }},

    -- when going to the end of the line in visual mode ignore whitespace characters
    {'v', '$', 'g_'},
   
    -- jk is escape, THEN move to the right to preserve the cursor position, unless
    -- at the first column.  <esc> will continue to work the default way.
    -- NOTE: this is a recursive mapping so anything bound (by a plugin) to <esc> still works
    {'i', 'jk', [[col('.') == 1 ? '<esc>' : '<esc>l']], { expr = true }},
    {'i', '<ESC>', [[col('.') == 1 ? '<esc>' : '<esc>l']], { expr = true }},
    
    -- Toggle top/center/bottom
    {'n', 'zz', [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']], { expr = true } },
})