-- TLDR: Conditionally modify character at end of line
-- Description:
-- This function takes a delimiter character and:
--   * removes that character from the end of the line if the character at the end
--     of the line is that character
--   * removes the character at the end of the line if that character is a
--     delimiter that is not the input character and appends that character to
--     the end of the line
--   * adds that character to the end of the line if the line does not end with
--     a delimiter
-- Delimiters:
-- - ","
-- - ";"
---@param character string
---@return function
local function modify_line_end_delimiter(character)
  local delimiters = { ',', ';' }
  return function()
    local line = vim.api.nvim_get_current_line()
    local last_char = line:sub(-1)
    if last_char == character then
      vim.api.nvim_set_current_line(line:sub(1, #line - 1))
    elseif vim.tbl_contains(delimiters, last_char) then
      vim.api.nvim_set_current_line(line:sub(1, #line - 1) .. character)
    else
      vim.api.nvim_set_current_line(line .. character)
    end
  end
end

require('v.utils.mappings').set_keybindings({

    -- modify line end delimiter
    {'n', '<localleader>,', modify_line_end_delimiter(',')},
    {'n', '<localleader>;', modify_line_end_delimiter(';')},

    -- Text Object: Entire buffer
    {'x', 'ie', [[gg0oG$]]},
    {'o', 'ie', [[<cmd>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>]]},

    -- Open comment files
    -- { 'n', '<leader>ez', ':e ~/.zshrc<cr>' },
    -- { 'n', '<leader>et', ':e ~/.tmux.conf<cr>' },
    {'n', '<leader>ev', [[<Cmd>vsplit $MYVIMRC<CR>]] },
    {'n', '<leader>ep', string.format('<Cmd>vsplit %s/lua/v/plugins/init.lua<CR>', vim.fn.stdpath('config'))},

    {'n', '<leader>sv', [[<Cmd>source $MYVIMRC<CR> <bar> :lua vim.notify('Sourced init.lua')<cr>]] },

    -- {'n', 'gf', '<CMD>e <cfile><CR>'},
})


