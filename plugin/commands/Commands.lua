---Return the path to the current lua file inside `nvim/lua/` in order to require it.
local function _get_current_require_path()
  local filepath = vim.api.nvim_buf_get_name(0)
  local regexp = [[^.\+nvim/lua/\(.\+\)\.lua$]]

  if not vim.regex(regexp):match_str(filepath) then
    return nil
  else
    filepath = vim.fn.substitute(filepath, regexp, [[\1]], '')
    filepath = vim.fn.substitute(filepath, [[\.lua$]], [[]], '')
    filepath = vim.fn.substitute(filepath, '/', '.', 'g')
    return filepath
  end
end

---Sources the current file if it's VimL and reloads (w/ `require`) if it's Lua.
function reload_or_source_current()
  local filetype = vim.opt_local.ft._value
  local require_path = _get_current_require_path()
  local action

  if filetype == 'lua' and require_path then
    require('v.utils.wrappers').reload(require_path)
    action = 'Reloaded '
  elseif filetype == 'vim' or filetype == 'lua' then
    vim.cmd('source %')
    action = 'Sourced '
  else
    return
  end

  vim.notify(action .. '"' .. vim.fn.expand('%') .. '".', 'info', {
    title = 'File reloading...',
  })
end

v.set_commands({
    -- how many times does this pattern appear in the file
    { 'Count', 'keeppatterns %s/<args>//gn | noh', { nargs = 1 } },

    -- saves buffer and then closes it
    { 'BqWrite', 'update | BufClose' },

    -- LSP
    { 'Format', 'lua vim.lsp.buf.format({async = true})' },
    { 'FT', 'lua vim.lsp.buf.format({async = true})' },
    { 'LQF', 'lua vim.diagnostic.setqflist()' },

    -- wrappers
    { 'P', 'lua require("v.utils.wrappers").inspect(<args>)', { nargs = 1 } },
    { 'R', 'call v:lua.reload_or_source_current()' },
})