-- If you want to manually enable a config category or a single config file, you require this file

local req_submodule = require('v.utils.wrappers').get_require_submodule('v.plugins-config')

local M = {
    -- general = req_submodule('basic'),
    themes = req_submodule('themes'),
    -- providers = req_submodule('providers'),
    -- builtin = req_submodule('builtin'),
    -- lsp = req_submodule('lsp'),
    -- handlers = req_submodule('handlers'),
}

return M