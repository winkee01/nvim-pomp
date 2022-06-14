return function()

  -- TODO: 
  -- https://github.com/danielnehrig/nvim/blob/master/lua/plugins/dashboard/init.lua

  -- v.set_viml_options('dashboard', {
  --     disable_at_vimenter = 1, -- Open it manually
  --     disable_statusline = 1,
  --     default_executive = 'telescope',

  --     custom_header = require('v.utils').ascii.neovim_3,

  --     custom_section = {
  --         a = {
  --             description = { '  Find File                 SPC f f' },
  --             command = 'Telescope find_files',
  --         },
  --         b = {
  --             description = { '  Grep                      SPC f p' },
  --             command = 'Telescope live_grep',
  --         },
  --         c = {
  --             description = { '洛 New File                  CMD ene' },
  --             command = 'DashboardNewFile',
  --         },
  --     },

  --     custom_footer = { '      ' },
  -- })

  vim.g.dashboard_default_executive = "telescope"
  vim.g.dashboard_custom_footer = { "https://github.com/winkee01/nvim-pomp" }

  vim.g.dashboard_custom_section = {
    -- a = { description = { "  Projects              " }, command = "Telescope projects" }, -- project.nvim
    -- a = { description = { "  Projects              " }, command = "Telescope session-lens search_session" }, -- project.nvim
    b = { description = { "  Recently files        " }, command = "Telescope oldfiles" },
    d = { description = { "  Edit Projects         " }, command = "edit ~/.local/share/nvim/project_nvim/project_history", },
    e = { description = { "  Edit .bashrc          " }, command = "edit ~/.bashrc" },
    f = { description = { "  Edit init.lua         " }, command = "edit ~/.config/nvim/init.lua" },
    g = { description = { "  Find file             " }, command = 'Telescope find_files'},
    h = { description = { "  Find text             " }, command = 'Telescope live_grep'},
    i = { description = { "  Change Theme           "}, command = 'Telescope colorscheme'},
  }

  vim.g.dashboard_custom_header = {
    [[ ██╗    ██╗██╗███╗   ██╗██╗  ██╗███████╗███████╗ ]],
    [[ ██║    ██║██║████╗  ██║██║ ██╔╝██╔════╝██╔════╝ ]],
    [[ ██║ █╗ ██║██║██╔██╗ ██║█████╔╝ █████╗  █████╗ ]],
    [[ ██║███╗██║██║██║╚██╗██║██╔═██╗ ██╔══╝  ██╔══╝ ]],
    [[ ╚███╔███╔╝██║██║ ╚████║██║  ██╗███████╗███████╗ ]],
    [[  ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚══════╝ ]],
    [[                                                   ]],
    [[                [ version : 1.0.0 ]                ]],
  }
end
