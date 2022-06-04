local M = {}

function M.setup()
  if v.plugin_loaded('which-key') then
    require('which-key').register({
      ['<localleader>g'] = {
        s = 'neogit: open status buffer',
        c = 'neogit: open commit buffer',
        l = 'neogit: open pull popup',
        p = 'neogit: open push popup',
      },
    })
  end
end

function M.config()
  local neogit = require('neogit')
  neogit.setup({
    disable_signs = false,
    disable_hint = true,
    disable_commit_confirmation = true,
    disable_builtin_notifications = true,
    disable_insert_on_commit = false,
    signs = {
      section = { '', '' }, -- "", ""
      item = { '▸', '▾' },
      hunk = { '樂', '' },
    },
    integrations = {
      diffview = true,
    },
  })
  v.map('n', '<localleader>gs', function()
    neogit.open()
  end)
  v.map('<localleader>gc', function()
    neogit.open({ 'commit' })
  end)
  v.map('<localleader>gl', neogit.popups.pull.create)
  v.map('<localleader>gp', neogit.popups.push.create)
end

return M
