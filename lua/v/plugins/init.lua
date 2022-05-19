local utils = require('v.utils.plugins')

local conf = utils.conf
local use_local = utils.use_local
local packer_notify = utils.packer_notify

local fn = vim.fn
local fmt = string.format

local PACKER_COMPILED_PATH = fn.stdpath('cache') .. '/packer/packer_compiled.lua'

-----------------------------------------------------------------------------//
-- Bootstrap Packer {{{3
-----------------------------------------------------------------------------//
utils.bootstrap_packer()
----------------------------------------------------------------------------- }}}1
-- cfilter is a default plugin provided by default ($RUNTIME/pack/dist/opt/cfilter)
-- it allows filter down an existing quickfix list
vim.cmd('packadd! cfilter')

---@see: https://github.com/lewis6991/impatient.nvim/issues/35
-- bootstrap_packer() has executed packer.sync(), so it's ok to do require here
v.safe_require('impatient')

local packer = require('packer')
--- NOTE "use" functions cannot call *upvalues* i.e. the functions
--- passed to setup or config etc. cannot reference aliased functions
--- or local variables
packer.startup({
  function(use, use_rocks)
    -- FIXME: this no longer loads the local plugin since the compiled file now
    -- loads packer.nvim so the local alias(local-packer) does not work
    use_local({ 'wbthomason/packer.nvim', local_path = 'contributing', opt = true })
    use({
      'NTBBloodbath/doom-one.nvim',
      config = function()
        require('doom-one').setup({
          pumblend = {
            enable = true,
            transparency_amount = 3,
          },
        })
      end,
    })
    -----------------------------------------------------------------------------//
    -- Core {{{3
    -----------------------------------------------------------------------------//
    use_rocks('penlight')

    -- TODO: this fixes a bug in neovim core that prevents "CursorHold" from working
    -- hopefully one day when this issue is fixed this can be removed
    -- @see: https://github.com/neovim/neovim/issues/12587
    use('antoinemadec/FixCursorHold.nvim')
    use('kyazdani42/nvim-web-devicons')
    use('lewis6991/impatient.nvim')
    use({
      'SmiteshP/nvim-gps',
      requires = 'nvim-treesitter/nvim-treesitter',
      config = function()
        require('nvim-gps').setup({})
      end,
    })
    use({
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = conf('treesitter'),
      local_path = 'contributing',
    })
    use({ 'b0o/incline.nvim', config = conf('incline') })
    ---------------------------------------------------------------------------------
  end,
  log = { level = 'info' },
  config = {
    max_jobs = 50,
    compile_path = PACKER_COMPILED_PATH,
    display = {
      prompt_border = v.style.current.border,
      open_cmd = 'silent topleft 65vnew',
    },
    git = {
      clone_timeout = 240,
    },
    profile = {
      enable = true,
      threshold = 1,
    },
  },
})

v.command('PackerCompiledEdit', function()
  vim.cmd(fmt('edit %s', PACKER_COMPILED_PATH))
end)

v.command('PackerCompiledDelete', function()
  vim.fn.delete(PACKER_COMPILED_PATH)
  packer_notify(fmt('Deleted %s', PACKER_COMPILED_PATH))
end)

if not vim.g.packer_compiled_loaded and vim.loop.fs_stat(PACKER_COMPILED_PATH) then
  v.source(PACKER_COMPILED_PATH)
  vim.g.packer_compiled_loaded = true
end

v.augroup('PackerSetupInit', {
  {
    event = 'BufWritePost',
    pattern = { '*/v/plugins/*.lua' },
    description = 'Packer setup and reload',
    command = function()
      v.invalidate('v.plugins', true)
      packer.compile()
    end,
  },
})
