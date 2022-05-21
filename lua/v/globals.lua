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

---Require a module using [pcall] and report any errors
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
function v.command(name, rhs, opts)
  opts = opts or {}
  api.nvim_create_user_command(name, rhs, opts)
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
    return require(fmt('v.packer.config.%s', name))
end

---create a mapping function factory
---@param mode string
---@param o table
---@return fun(lhs: string, rhs: string|function, opts: table|nil) 'create a mapping'
local function make_mapper(mode, o)
  -- copy the opts table as extends will mutate the opts table passed in otherwise
  local parent_opts = vim.deepcopy(o)
  ---Create a mapping
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts table
  return function(lhs, rhs, opts)
    -- If the label is all that was passed in, set the opts automagically
    opts = type(opts) == 'string' and { desc = opts } or opts and vim.deepcopy(opts) or {}
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('keep', opts, parent_opts))
  end
end

local map_opts = { remap = true, silent = true }
local noremap_opts = { silent = true }

-- A recursive commandline mapping
v.nmap = make_mapper('n', map_opts)
-- A recursive select mapping
v.xmap = make_mapper('x', map_opts)
-- A recursive terminal mapping
v.imap = make_mapper('i', map_opts)
-- A recursive operator mapping
v.vmap = make_mapper('v', map_opts)
-- A recursive insert mapping
v.omap = make_mapper('o', map_opts)
-- A recursive visual & select mapping
v.tmap = make_mapper('t', map_opts)
-- A recursive visual mapping
v.smap = make_mapper('s', map_opts)
-- A recursive normal mapping
v.cmap = make_mapper('c', { remap = true, silent = false })
-- A non recursive normal mapping
v.nnoremap = make_mapper('n', noremap_opts)
-- A non recursive visual mapping
v.xnoremap = make_mapper('x', noremap_opts)
-- A non recursive visual & select mapping
v.vnoremap = make_mapper('v', noremap_opts)
-- A non recursive insert mapping
v.inoremap = make_mapper('i', noremap_opts)
-- A non recursive operator mapping
v.onoremap = make_mapper('o', noremap_opts)
-- A non recursive terminal mapping
v.tnoremap = make_mapper('t', noremap_opts)
-- A non recursive select mapping
v.snoremap = make_mapper('s', noremap_opts)
-- A non recursive commandline mapping
v.cnoremap = make_mapper('c', { silent = false })

