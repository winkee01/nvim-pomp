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

require('v.utils.mappings').set_keybindings({
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

require('v.utils.mappings').set_keybindings({
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
require('v.utils.mappings').set_keybindings({
  {'n', 'gf', [[ :lua v.open_path()<CR> ]] },
})

