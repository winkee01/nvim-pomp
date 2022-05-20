local req_submodule = require('v.utils.wrappers').get_require_submodule('v.packer.config')

local M = {
    -- general = req_submodule('basic'),
    appearance = req_submodule('themes'),
    -- providers = req_submodule('providers'),
    -- builtin = req_submodule('builtin'),
    -- lsp = req_submodule('lsp'),
    -- handlers = req_submodule('handlers'),
}

return M