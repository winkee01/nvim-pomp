local lsp_utils = require('v.utils.lsp')

-- configs for
-- 1. diagnostics
-- 2. formatting
-- 3. hover
-- 4. signatureHelp

v.lsp = {}

v.lsp.capabilities = lsp_utils.update_capabilities()

v.lsp.on_attach = function(client, bufnr)
  lsp_utils.setup_autocommands(client, bufnr)
  lsp_utils.setup_mappings(client)

  -- disable lsp-server's formatting capability
  client.server_capabilities.document_formatting = false
  client.server_capabilities.document_range_formatting = false

  local format_ok, lsp_format = pcall(require, 'lsp-format')
  if format_ok then
    lsp_format.on_attach(client)
  end

  if client.server_capabilities.definitionProvider then
    vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
  end

  if client.server_capabilities.documentFormattingProvider then
    vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr()'
  end

  -- require("lsp_signature").on_attach {
  --   hint_enable = false,
  --   hi_parameter = "QuickFixLine",
  --   handler_opts = {
  --       border = vim.g.floating_window_border,
  --   },
  -- }
end

-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//

-- key:value => lsp_server_name:config
-- key has to be the one in below list
-- https://github.com/williamboman/nvim-lsp-installer#available-lsps
-- e.g. sumneko_lua is indeed require'lspconfig'.sumneko_lua,
-- because lsp_installer has defined that.
v.lsp.servers = {
  -- efm = require('v.plugins-config.lsp.servers.efm'),
  sumneko_lua = require(v.plugins_config_path_root .. '.lsp.servers.sumneko_lua'),  -- lua
  tsserver = require(v.plugins_config_path_root .. '.lsp.servers.tsserver'),        -- javascript
  cssls = require(v.plugins_config_path_root .. '.lsp.servers.cssls'),              -- css
  html = require(v.plugins_config_path_root .. '.lsp.servers.html'),                -- html
  emmet_ls = require(v.plugins_config_path_root .. '.lsp.servers.emmetls'),         -- emmet
  pyright = require(v.plugins_config_path_root .. '.lsp.servers.pyright'),          -- python
  gopls = require(v.plugins_config_path_root .. '.lsp.servers.gopls'),              -- go
  -- gopls = false,  -- use go.nvim
  clangd = require(v.plugins_config_path_root .. '.lsp.servers.clangd'),            -- c,cpp
  rust_analyzer = require(v.plugins_config_path_root .. '.lsp.servers.rust_analyzer'),  -- rust
  jsonls = require(v.plugins_config_path_root .. '.lsp.servers.jsonls'),            -- json
  texlab = require(v.plugins_config_path_root .. '.lsp.servers.texlab'),            -- latex
  ltex = require(v.plugins_config_path_root .. '.lsp.servers.ltex'),                -- latex
  yamlls = require(v.plugins_config_path_root .. '.lsp.servers.yamlls'),
  bashls = require(v.plugins_config_path_root .. '.lsp.servers.bashls'),
  dockerls = require(v.plugins_config_path_root .. '.lsp.servers.dockerls'),
  vimls = {},
  cmake = {},
  -- diagnosticls = require("v.plugins-config.lsp.servers.diagnosticls"),
  -- cmake = require("v.plugins-config.lsp.servers.cmake"),
  -- "sqlls",       -- sql
  -- pylsp = require("v.plugins-config.lsp.servers.pylsp"),          -- python
  -- "jdtls",          -- java
}

---Logic to (re)start installed language servers for use initialising lsps
---and restarting them on installing new ones
---@param conf table<string, any>
---@return table<string, any>
function v.lsp.get_server_config(conf)
  local conf_type = type(conf)
  local config = conf_type == 'table' and conf or conf_type == 'function' and conf() or {}
  
  config.on_attach = config.on_attach or v.lsp.on_attach
  config.capabilities = config.capabilities or v.lsp.capabilities

  return config
end

return function()
  -- Call nvim-lsp-installer's setup() function before you call server's setup()
  -- :h nvim-lsp-installer-quickstart
  require('nvim-lsp-installer').setup({
    ensure_installed = v.lsp.servers,
    automatic_installation = true,
  })
  require(v.plugins_config_path_root .. '.lsp.lsp.diagnostic') -- apply diagnostic configs

  if vim.v.vim_did_enter == 1 then
    return
  end
  for name, config in pairs(v.lsp.servers) do
    if config then
      require('lspconfig')[name].setup(v.lsp.get_server_config(config))
    end
  end
end

