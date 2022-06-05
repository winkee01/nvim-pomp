vim.g.os = vim.loop.os_uname().sysname
vim.g.open_command = vim.g.os == 'Darwin' and 'open' or 'xdg-open'
vim.g.vim_dir = vim.fn.expand(vim.fn.stdpath('data'))

vim.g.did_load_filetypes = 0 -- deactivate vim based filetype detection
------------------------------------------------------------------------
-- Leader bindings
------------------------------------------------------------------------
vim.g.mapleader = ',' -- Remap leader key
vim.g.maplocalleader = ' ' -- Local leader is <Space>

local ok, reload = pcall(require, 'plenary.reload')
RELOAD = ok and reload.reload_module or function(...)
  return ...
end

function R(name)
  RELOAD(name)
  return require(name)
end

----------------------------------------------------------------------------------------------------
-- Default plugins
-- 1) disable netrw
-- netrw plugin is shipped with vim by default as the default filebrowser
----------------------------------------------------------------------------------------------------
-- vim.g.loaded_netrwPlugin = 1
------------------------------------------------------------------------
-- Plugin Configurations
------------------------------------------------------------------------
-- Order matters here as globals needs to be instantiated first etc.
R('v.globals')
R('v.styles')
R('v.settings')
R('v.packer')
R('v.mappings')
