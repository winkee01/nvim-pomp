-- Open Google for search
-- On macOS, it willl call 'open' command to open a browser
-- On Linux, it will call 'xdg_open' command to open a browser
-- Credit: June Gunn <Leader>?/! | Google it / Feeling lucky
function v.mappings.google(pattern, lucky)
  local query = '"' .. vim.fn.substitute(pattern, '["\n]', ' ', 'g') .. '"'
  query = vim.fn.substitute(query, '[[:punct:] ]', [[\=printf("%%%02X", char2nr(submatch(0)))]], 'g')
  vim.fn.system(
    vim.fn.printf(
      vim.g.open_command .. ' "https://www.google.com/search?%sq=%s"',
      lucky and 'btnI&' or '',
      query
    )
  )
end

v.set_keybindings({
  { 'n', '<localleader>?', [[:lua v.mappings.google(vim.fn.expand("<cWORD>"), false)<cr>]] },
  { 'n', '<localleader>!', [[:lua v.mappings.google(vim.fn.expand("<cWORD>"), true)<cr>]] },
  { 'x', '<localleader>?', [["gy:lua v.mappings.google(vim.api.nvim_eval("@g"), false)<cr>gv]] },
  { 'x',
    '<localleader>!',
    [["gy:lua v.mappings.google(vim.api.nvim_eval("@g"), false, true)<cr>gv]]
  },
})

-- Open a link
local function open(path)
  vim.fn.jobstart({ vim.g.open_command, path }, { detach = true })
  vim.notify(string.format('Opening %s', path))
end

function v.open_link()
  local file = vim.fn.expand('<cfile>')
  if vim.fn.isdirectory(file) > 0 then
    vim.cmd('edit ' .. file)
  else
    open(file)
  end
end

v.set_keybindings({
  {'n', 'gx', [[ :lua v.open_link()<CR> ]] },
})


-- Open a filepath or a github page for a repo or a plugin name
-- Open a repository from an authorname/repository string
-- e.g. 'akinso/example-repo'
function v.open_path()
  local path = vim.fn.expand('<cfile>')
  if path:match('https://') then
    return vim.cmd('norm gx')
  end
  -- Any URI with a protocol segment
  local protocol_uri_regex = '%a*:%/%/[%a%d%#%[%]%-%%+:;!$@/?&=_.,~*()]*'
  if path:match(protocol_uri_regex) then
    return vim.cmd('norm! gf')
  end

  -- consider anything that looks like string/string a github link
  local plugin_url_regex = '[%a%d%-%.%_]*%/[%a%d%-%.%_]*'
  local link = string.match(path, plugin_url_regex)
  if link then
    return open(string.format('https://www.github.com/%s', link))
  end
  return vim.cmd('norm! gf')
end


-- Note: 
-- gf by default open a filepath under cursor
-- if not a filepath, it will pop an error, 
-- if you want to open it anyway, you can do: nnoremap('gf', '<Cmd>e <cfile><CR>')
-- Here, we extend gf to open a filapath or a github page for the repo
v.set_keybindings({
  {'n', 'gf', [[ :lua v.open_path()<CR> ]] },
})

---Executes the current line in VimL or Lua
---@return nil
function exec_line_or_make()
  local filetype = vim.opt_local.ft._value

  if vim.tbl_contains({ 'c', 'cpp' }, filetype) then
    vim.api.nvim_command('make')
    return
  elseif not vim.tbl_contains({ 'lua', 'vim' }, filetype) then
    return
  end

  local mode = vim.api.nvim_get_mode().mode
  local line = vim.fn.line('.')
  local command

  if mode == 'V' then
    local start_visual = vim.fn.line('v')
    command = vim.api.nvim_buf_get_lines(0, start_visual - 1, line, false)
    line = math.min(line, start_visual) .. ':' .. math.max(line, start_visual)
  elseif mode == 'n' then
    command = { vim.api.nvim_get_current_line() }
  else
    return
  end

  if filetype == 'lua' then
    command = 'lua << EOF\n' .. table.concat(command, '\n') .. '\nEOF'
  end

  local ok, _ = pcall(vim.api.nvim_exec, command, false)

  local file = string.gsub(vim.api.nvim_buf_get_name(0), [[^.+/(%w+/%w+)]], '%1')
  vim.notify(
    ('Executed %s, %s.'):format(file, line),
    ok and vim.log.levels.INFO or vim.log.levels.ERROR,
    { title = 'Line Execution' }
  )
end

v.set_keybindings({
  -- execute currenbt line/selection
    {
      { 'n', 'v' },
      '<leader>x',
      function()
        exec_line_or_make()
      end,
    },

    ---source/reload current file
    {
      { 'n' },
      '<leader>xx',
      function()
        vim.cmd('R') -- This is a commmand from plugin/commands
      end,
    },
})

