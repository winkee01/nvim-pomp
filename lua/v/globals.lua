-- local wrappers = require('v.utils.wrappers')

-- function _G.t(key)
--     return wrappers.termcode(key)
-- end

-- function _G.R(module)
--     return wrappers.reload(module)
-- end

-- function _G.P(...)
--     return wrappers.inspect(...)
-- end

-- function _G.D(...)
--     return wrappers.dump_text(...)
-- end


local fn = vim.fn
local api = vim.api
local fmt = string.format

----------------------------------------------------------------------------------------------------
-- Global namespace
----------------------------------------------------------------------------------------------------

_G.v = {
  -- some vim mappings require a mixture of commandline commands and function calls
  -- this table is place to store lua functions to be called in those mappings
  mappings = {},
}

----------------------------------------------------------------------------------------------------
-- Utils
----------------------------------------------------------------------------------------------------
---Find an item in a list
---@generic T
---@param haystack T[]
---@param matcher fun(arg: T):boolean
---@return T
function v.find(haystack, matcher)
  local found
  for _, needle in ipairs(haystack) do
    if matcher(needle) then
      found = needle
      break
    end
  end
  return found
end

local installed
---Check if a plugin is on the system not whether or not it is loaded
---@param plugin_name string
---@return boolean
function v.plugin_installed(plugin_name)
  if not installed then
    local dirs = fn.expand(fn.stdpath('data') .. '/site/pack/packer/start/*', true, true)
    local opt = fn.expand(fn.stdpath('data') .. '/site/pack/packer/opt/*', true, true)
    vim.list_extend(dirs, opt)
    installed = vim.tbl_map(function(path)
      return fn.fnamemodify(path, ':t')
    end, dirs)
  end
  return vim.tbl_contains(installed, plugin_name)
end

---NOTE: this plugin returns the currently loaded state of a plugin given
---given certain assumptions i.e. it will only be true if the plugin has been
---loaded e.g. lazy loading will return false
---@param plugin_name string
---@return boolean?
function v.plugin_loaded(plugin_name)
  local plugins = packer_plugins or {}
  return plugins[plugin_name] and plugins[plugin_name].loaded
end

---Check whether or not the location or quickfix list is open
---@return boolean
function v.is_vim_list_open()
  for _, win in ipairs(api.nvim_list_wins()) do
    local buf = api.nvim_win_get_buf(win)
    local location_list = fn.getloclist(0, { filewinid = 0 })
    local is_loc_list = location_list.filewinid > 0
    if vim.bo[buf].filetype == 'qf' or is_loc_list then
      return true
    end
  end
  return false
end

---Determine if a value of any type is empty
---@param item any
---@return boolean
function v.is_empty(item)
  if not item then
    return true
  end
  local item_type = type(item)
  if item_type == 'string' then
    return item == ''
  elseif item_type == 'table' then
    return vim.tbl_isempty(item)
  end
end

---Wrapper for pcall
---@param module string
---@param opts table?
---@return boolean, any
function v.safe_require(module, opts)
  opts = opts or { silent = false }
  local ok, result = pcall(require, module)
  if not ok and not opts.silent then
    vim.notify(result, vim.log.levels.ERROR, { title = fmt('Error requiring: %s', module) })
  end
  return ok, result
end

---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name string
---@param commands Autocommand[]
---@return number
function v.augroup(name, commands)
  local id = api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    local is_callback = type(autocmd.command) == 'function'
    api.nvim_create_autocmd(autocmd.event, {
      group = name,
      pattern = autocmd.pattern,
      desc = autocmd.description,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return id
end


---Create an nvim command
---@param name any
---@param rhs string|fun(args: CommandArgs)
---@param opts table?
function v.create_command(name, rhs, opts)
  -- print(vim.inspect(type(rhs)))
  opts = opts or {}
  api.nvim_create_user_command(name, rhs, opts)
end

---Wrapper for defining commands with `:command`
---@param lhs string the command's name
---@param rhs string/function the command's action
---@param opts table<string,string|number|boolean> the command's attributes (see `:h :command`)
---@return nil
---
---opts.def_bang is an custom boolean option (default `true`) that specifies if
---the command should be defined with a bang (`:command!` instead of `:command`)
function v.run_command(lhs, rhs, opts)
  if (type(lhs) ~= 'string' or (type(rhs) ~= 'string' and type(rhs) ~= 'function')) or (opts and type(opts) ~= 'table') then
    vim.api.nvim_notify('Invalid parameter(s).', vim.log.levels.ERROR, {
      title = 'Commands',
    })
    require('v.utils.wrappers').inspect(lhs, rhs, opts)
    return
  end

  opts = vim.tbl_extend('force', { def_bang = true }, opts or {})
  local bang = opts.def_bang
  opts.def_bang = nil

  local cmd = 'command' .. (bang and '!' or '')

  for opt, value in pairs(opts) do
    if value then
      local setv = type(value) ~= 'boolean'
      cmd = ('%s -%s'):format(cmd, opt) .. (setv and '=' .. value or '')
    end
  end

  cmd = ('%s %s %s'):format(cmd, lhs, rhs)

  vim.api.nvim_command(cmd)
end

---Wrapper for defining multiple commands (`:h :command`) in one function call
---@param args string[][] list of command arrays: { lhs, rhs, opts }
---@return nil
function v.set_commands(args)
  for _, cmd_table in ipairs(args) do
    v.run_command(unpack(cmd_table))
  end
end

---Source a lua or vimscript file
---@param path string path relative to the nvim directory
---@param prefix boolean?
function v.source(path, prefix)
  if not prefix then
    vim.cmd(fmt('source %s', path))
  else
    vim.cmd(fmt('source %s/%s', vim.g.vim_dir, path))
  end
end

---Check if a cmd is executable
---@param e string
---@return boolean
function v.executable(e)
  return fn.executable(e) > 0
end

---A terser proxy for `nvim_replace_termcodes`
---@param str string
---@return string
function v.replace_termcodes(str)
  return api.nvim_replace_termcodes(str, true, true, true)
end

---check if a certain feature/version/commit exists in nvim
---@param feature string
---@return boolean
function v.has(feature)
  return vim.fn.has(feature) > 0
end


---Require a plugin config
---@param name string
---@return any
function v.conf(name)
    return require(fmt('v.plugins-config.%s', name))
end

function v.conf_wrapper(category)
  return function(name)
    return function()
      require(fmt('v.plugins-config.%s.%s', category, name))
    end
  end
end

function v.conf_ex(category)
  return function(name)
    return require(fmt('v.plugins-config.%s.%s', category, name))
  end
end

function v.conf_path(category)
  return function(name)
    return fmt('v.plugins-config.%s.%s', category, name)
  end
end


local t = v.replace_termcodes

-- TODO: setup whichkey registering on the fly
-- https://github.com/folke/which-key.nvim#-setup
-- https://github.com/akinsho/dotfiles/blob/c81dadf0c570ce39543a9b43a75f41256ecd03fc/.config/nvim/lua/as/plugins/lspconfig.lua#L61-L119
-- https://github.com/folke/which-key.nvim/issues/153

---Wrapper for `vim.keymap.set`
---@param mode string|string[] mode or list of modes (`:h map-modes`)
---@param lhs string keybinding
---@param rhs string|function action
---@param opts table<string, boolean|string> usual map options + `buffer` (`:h vim.keymap.set`)
function v.map(mode, lhs, rhs, opts)
  if not lhs then
    vim.api.nvim_notify('No LHS.', vim.log.levels.ERROR, {
      title = 'Mapping',
    })
    return
  end

  local options = vim.tbl_extend('force', {
    silent = true,
    nowait = true, -- TODO: does this break anything?
    replace_keycodes = false,
  }, opts or {})

  if options.buffer and type(options.buffer) ~= 'number' then
    options.buffer = 0
  end

  vim.keymap.set(mode, lhs, rhs, options)
end

function v.set_keybindings(args, common_opts)
  common_opts = common_opts or {noremap = true, silent = true}
  for _, map_table in ipairs(args) do
    local mode, lhs, rhs, opts = unpack(map_table)
    local options = vim.tbl_extend('force', common_opts or {}, opts or {})
    v.map(mode, lhs, rhs, options)
  end
end

---Sets VimL options for a plugin from a `opts` table.
function v.set_viml_options(lead, opts, unique_value)
  lead = lead or ''

  local no_uppercase_initial = lead:match('^[^A-Z]')
  local is_caps_lock = lead:match('^[A-Z]+$')
  local has_no_separator = lead:match('[a-zA-Z0-9]$')

  if (no_uppercase_initial or is_caps_lock) and has_no_separator then
    lead = lead .. '_'
  end

  if unique_value then
    if type(unique_value) == 'boolean' then
      unique_value = unique_value and 1 or 0
    end

    for i, option in ipairs(opts) do
      vim.g[lead .. option] = unique_value
      opts[i] = nil
    end
  end

  for option, value in pairs(opts) do
    if type(value) == 'boolean' then
      value = value and 1 or 0
    end

    vim.g[lead .. option] = value
  end
end


function v.is_buffer_empty()
    -- Check whether the current buffer is empty
    return vim.fn.empty(vim.fn.expand('%:t')) == 1
end

function v.has_width_gt(cols)
    -- Check if the windows width is greater than a given number of columns
    return vim.fn.winwidth(0) / 2 > cols
end
