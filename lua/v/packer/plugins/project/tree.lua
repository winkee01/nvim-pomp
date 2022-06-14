return function()
  local nvim_tree = require'nvim-tree'
  local map = vim.api.nvim_set_keymap
  local opt = {noremap = true, silent = true }
  map("n", "µ", ":NvimTreeToggle<CR>", opt)

  local list_keys = {
    -- Open a file or directory
    { key = {"<CR>", "o", "<2-LeftMouse>"}, action = "edit" },

    -- Open file in splits
    { key = "v", action = "vsplit" },
    { key = "h", action = "split" },
    { key = "<c-t>", action = "tabnew" },
    -- Display hidden files
    { key = "i", action = "toggle_ignored" }, -- Ignore (node_modules)
    { key = ".", action = "toggle_dotfiles" }, -- Hide (dotfiles)
    -- Operations on file
    { key = "<F5>", action = "refresh" },
    { key = "a", action = "create" },
    { key = "d", action = "remove" },
    { key = "r", action = "rename" },
    { key = "x", action = "cut" },
    { key = "c", action = "copy" },
    { key = "p", action = "paste" },
    { key = "s", action = "system_open" },
  }

  nvim_tree.setup({
    -- open the tree when running this setup function
    open_on_setup       = false,
    -- will not open on setup if the filetype is in this list
    ignore_ft_on_setup  = {},
    -- Don't display git status icon
    git = {
      enable = false,
      ignore = true,
      timeout = 500,
    },
    -- project plugin
    update_cwd = true,
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
    -- auto_close = false, -- deprecated, nvim-notify will display a notification
    -- Hide dotfiles and node_modules directory
    filters = {
      dotfiles = true,
      custom = { "node_modules", "undodir" },
      exclude = {},
    },
    view = {
      width = 30,
      side = "left",
      hide_root_folder = false,
      -- Auto resize when open the first file from nvim-tree
      -- auto_resize = true,
      -- Customize key mappings for nvim-tree
      mappings = {
        custom_only = false,
        list = list_keys,
      },
      -- display line numbers
      number = false,
      relativenumber = false,
      -- display icon
      signcolumn = "yes",
    },
    -- npm install -g wsl-open
    -- https://github.com/4U6U57/wsl-open/
    system_open = {
      -- windows WSL
      -- cmd = "wsl-open",
      -- macOS
      -- the command to run this, leaving nil should work in most cases
      cmd = "open",
    },
    diagnostics = {
      enable = false,
      icons  = {
        hint    = "",
        info    = "",
        warning = "",
        error   = "",
      }
    },
  })
end