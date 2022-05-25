local utils = require('v.utils.packer')

local conf = utils.conf
local use_local = utils.use_local
local packer_notify = utils.packer_notify

local fn = vim.fn
local fmt = string.format

-----------------------------------------------------------------------------//
-- Bootstrap Packer {{{3
-----------------------------------------------------------------------------//
utils.bootstrap_packer()

-- cfilter is a default plugin provided by default ($RUNTIME/pack/dist/opt/cfilter)
-- it allows filter down an existing quickfix list
vim.cmd('packadd! cfilter')

---@see: https://github.com/lewis6991/impatient.nvim/issues/35
-- bootstrap_packer() has executed packer.sync(), so it's ok to do require here
v.safe_require('impatient')

v.run_command('PackerCompiledEdit', function()
  vim.cmd(fmt('edit %s', utils.compile_path))
end)

v.run_command('PackerCompiledDelete', function()
  vim.fn.delete(utils.compile_path)
  packer_notify(fmt('Deleted %s', utils.compile_path))
end)

if not vim.g.packer_compiled_loaded and vim.loop.fs_stat(utils.compile_path) then
  v.source(utils.compile_path)
  vim.g.packer_compiled_loaded = true
end

-- Auto compile packer when plugins-config/*.lua was modified
v.augroup('PackerSetupInit', {
  {
    event = 'BufWritePost',
    pattern = { '*/v/plugins-config/*/*.lua' },
    description = 'Packer setup and reload',
    command = function()
      v.invalidate('v.plugins-config', true)
      packer.compile()
    end,
  },
})