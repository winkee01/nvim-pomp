local fmt = string.format
local fn = vim.fn
local api = vim.api
local P = v.style.palette
local L = v.style.lsp.colors
local levels = vim.log.levels


local base3 = '#23272e'
local base6 = '#73797e'
local base8 = '#DFDFDF'
local bg_popup = '#3E4556'
local fg = '#bbc2cf'
local bg = '#282c34'
local statusline_hi = { fg = base8, bg = base3 }
local statuslinenc_hi = { fg = base6, bg = bg_popup }
local transparent_bg = false
local normal_hi = { fg = fg, bg = bg }


local M = {}

---Wrapper for defining highlights like with `:highlight`
---@param groups string|string[] the highlighting groups' names
---@param tbl table<string,string> the highlighting modifications
---@return nil
M.highlight = function(groups, tbl)
  if type(groups) == 'string' then
    groups = { groups }
  end

  if
    type(groups) ~= 'table'
    or type(tbl) ~= 'table'
    or (tbl.link and type(tbl.link) ~= 'string')
  then
    vim.api.nvim_notify('Invalid parameter(s).', vim.log.levels.ERROR, {
      title = 'Highlights',
    })
    require('v.utils.wrappers').inspect(groups, tbl)
    return
  end

  if tbl.link then
    for _, group in ipairs(groups) do
      vim.highlight.link(group, tbl.link, tbl.bang)
    end
    return
  end

  for pos, value in ipairs(tbl) do
    if value == 'transparent' then
      tbl.ctermbg = 'NONE'
      tbl.guibg = 'NONE'
    end

    tbl[pos] = nil
  end

  if type(tbl.gui) == 'table' then
    tbl.gui = table.concat(tbl.gui, ',')
  end

  if type(tbl.cterm) == 'table' then
    tbl.cterm = table.concat(tbl.cterm, ',')
  end

  local unlink = tbl.unlink
  tbl.unlink = nil

  -- TODO: swap for nvim_set_hl, nvim_buf_add_highlight
  for _, group in ipairs(groups) do
    if unlink then
      vim.highlight.link(group, 'NONE', true)
    end
    if tbl then
      vim.highlight.create(group, tbl)
    end
  end

  --[[ version using `:hi!`
        local cmd = 'hi! ' .. group

        for key, value in pairs(tbl) do
            if type(key) == 'string' and value and type(value) == 'string' then
                cmd = ('%s %s=%s'):format(cmd, key, value)
            elseif value == 'transparent' then
                cmd = cmd .. 'ctermbg=NONE guibg=NONE'
            end
        end

        vim.api.nvim_command(cmd)
    ]]
end

---@class HighlightTable
---@field groups string|string[] the highlighting groups' names
---@field tbl table<string,string> the highlighting modifications

---Wrapper for defining multiple highlights (`:h :highlight`) in one function call
---@param args HighlightTable[]
---@return nil
M.set_highlights = function(args)
  for _, tbl in ipairs(args) do
    M.highlight(unpack(tbl))
  end
end

---Convert a hex color to RGB
---@param color string
---@return number
---@return number
---@return number
local function hex_to_rgb(color)
  local hex = color:gsub('#', '')
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5), 16)
end

local function alter(attr, percent)
  return math.floor(attr * (100 + percent) / 100)
end

---@source https://stackoverflow.com/q/5560248
---@see: https://stackoverflow.com/a/37797380
---Darken a specified hex color
---@param color string
---@param percent number
---@return string
function M.alter_color(color, percent)
  local r, g, b = hex_to_rgb(color)
  if not r or not g or not b then
    return 'NONE'
  end
  r, g, b = alter(r, percent), alter(g, percent), alter(b, percent)
  r, g, b = math.min(r, 255), math.min(g, 255), math.min(b, 255)
  return fmt('#%02x%02x%02x', r, g, b)
end

--- Check if the current window has a winhighlight
--- which includes the specific target highlight
--- @param win_id integer
--- @vararg string
--- @return boolean, string
function M.winhighlight_exists(win_id, ...)
  local win_hl = vim.wo[win_id].winhighlight
  for _, target in ipairs({ ... }) do
    if win_hl:match(target) ~= nil then
      return true, win_hl
    end
  end
  return false, win_hl
end

---@param group_name string A highlight group name
local function get_hl(group_name)
  local ok, hl = pcall(api.nvim_get_hl_by_name, group_name, true)
  if ok then
    hl.foreground = hl.foreground and '#' .. bit.tohex(hl.foreground, 6)
    hl.background = hl.background and '#' .. bit.tohex(hl.background, 6)
    hl[true] = nil -- BUG: API returns a true key which errors during the merge
    return hl
  end

  -- set default
  -- if group_name == "Normal" then
  --   hl.foreground = 6043243
  --   hl.background = 1525315
  -- elseif group_name == 'StatusLine' then
  --   hi.forground = 327867
  --   hi.background = 231253
  -- end

  -- return hl
  return {}
end

---A mechanism to allow inheritance of the winhighlight of a specific
---group in a window
---@param win_id number
---@param target string
---@param name string
---@param fallback string
function M.adopt_winhighlight(win_id, target, name, fallback)
  local win_hl_name = name .. win_id
  local _, win_hl = M.winhighlight_exists(win_id, target)
  local hl_exists = fn.hlexists(win_hl_name) > 0
  if hl_exists then
    return win_hl_name
  end
  local parts = vim.split(win_hl, ',')
  local found = v.find(parts, function(part)
    return part:match(target)
  end)
  if not found then
    return fallback
  end
  local hl_group = vim.split(found, ':')[2]
  local bg = M.get_hl(hl_group, 'bg')
  if bg ~= 'NONE' then
    M.set_hl(win_hl_name, { background = bg, inherit = fallback })
  else
    if hl_group == 'StatusLine' then
      M.set_hl(win_hl_name, statusline_hi)
    elseif hl_group == 'Normal' then
      M.set_hl(win_hl_name, normal_hi)
    end
  end
  return win_hl_name
end

---This helper takes a table of highlights and converts any highlights
---specified as `highlight_prop = { from = 'group'}` into the underlying colour
---by querying the highlight property of the from group so it can be used when specifying highlights
---as a shorthand to derive the right color.
---For example:
---```lua
---  M.set_hl({ MatchParen = {foreground = {from = 'ErrorMsg'}}})
---```
---This will take the foreground colour from ErrorMsg and set it to the foreground of MatchParen.
---@param opts table<string, string|boolean|table<string,string>>
local function convert_hl_to_val(opts)
  for name, value in pairs(opts) do
    if type(value) == 'table' and value.from then
      opts[name] = M.get_hl(value.from, vim.F.if_nil(value.attr, name))
    end
  end
end

---@param name string
---@param opts table
function M.set_hl(name, opts)
  assert(name and opts, "Both 'name' and 'opts' must be specified")
  local hl = get_hl(opts.inherit or name)
  convert_hl_to_val(opts)
  opts.inherit = nil
  local ok, msg = pcall(api.nvim_set_hl, 0, name, vim.tbl_deep_extend('force', hl, opts))
  if not ok then
    vim.notify(fmt('Failed to set %s because: %s', name, msg))
  end
end

---Get the value a highlight group whilst handling errors, fallbacks as well as returning a gui value
---in the right format
---@param group string
---@param attribute string
---@param fallback string?
---@return string
function M.get_hl(group, attribute, fallback)
  if not group then
    vim.notify('Cannot get a highlight without specifying a group', levels.ERROR)
    return 'NONE'
  end
  local hl = get_hl(group)
  
  attribute = ({ fg = 'foreground', bg = 'background' })[attribute] or attribute
  local color = hl[attribute] or fallback
  if not color then
    -- vim.schedule(function()
    --   vim.notify(fmt('%s does not have attribute %s', group, attribute), levels.INFO)
    -- end)
    -- return 'NONE'
    local hlcolor
    if group == 'Normal' then
      hlcolor = normal_hi
    elseif group == 'StatusLine' then
      hlcolor = statusline_hi
    end

    return hlcolor
  end
  -- convert the decimal RGBA value from the hl by name to a 6 character hex + padding if needed
  return color
end

function M.clear_hl(name)
  assert(name, 'name is required to clear a highlight')
  api.nvim_set_hl(0, name, {})
end

---Apply a list of highlights
---@param hls table<string, table<string, boolean|string>>
function M.set_hi_all(hls)
  for name, hl in pairs(hls) do
    M.set_hl(name, hl)
  end
end

---------------------------------------------------------------------------------
-- Plugin highlights
---------------------------------------------------------------------------------
---Apply highlights for a plugin and refresh on colorscheme change
---@param name string plugin name
---@vararg table<string, table> map of highlights
function M.set_hi_plugin(name, hls)
  name = name:gsub('^%l', string.upper) -- capitalise the name for autocommand convention sake
  M.set_hi_all(hls)
  v.augroup(fmt('%sHighlightOverrides', name), {
    {
      event = 'ColorScheme',
      command = function()
        M.set_hi_all(hls)
      end,
    },
  })
end

return M

