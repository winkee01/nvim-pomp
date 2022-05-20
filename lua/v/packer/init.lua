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
----------------------------------------------------------------------------- }}}1
-- cfilter is a default plugin provided by default ($RUNTIME/pack/dist/opt/cfilter)
-- it allows filter down an existing quickfix list
vim.cmd('packadd! cfilter')

---@see: https://github.com/lewis6991/impatient.nvim/issues/35
-- bootstrap_packer() has executed packer.sync(), so it's ok to do require here
v.safe_require('impatient')

-- local packer = require('packer')