local req_submodule = require('v.utils.wrappers').get_require_submodule('v.packer.plugins')

local M = {
    basic       = req_submodule('basic'),
    themes      = req_submodule('themes'),
    appearance  = req_submodule('appearance'),
    enhancement = req_submodule('enhancement'),
    project     = req_submodule('project'),
    git         = req_submodule('git'),
    lang        = req_submodule('lang'),
    lsp         = req_submodule('lsp'),
}

return M