-- rust-analyzer, aka rls 2.0

-- local lspconfig = require 'lspconfig'

-- rust-analyzer
local opts = {
  -- settings = { ["rust-analyzer"] = {} },
  flags = {
    debounce_text_changes = 150,
  },
  -- capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  -- handlers = handlers,
  -- on_attach = function(client, bufnr)
  --   client.server_capabilities.document_formatting = false
  --   client.server_capabilities.document_range_formatting = false

  --   local function buf_set_keymap(...)
  --     vim.api.nvim_buf_set_keymap(bufnr, ...)
  --   end
  --   require('keybindings_lsp').mapLSP(buf_set_keymap)
  --   vim.cmd('autocmd BufWritePre <buffer> :silent! lua vim.lsp.buf.formatting_sync()')
  -- end,
  cmd = { "rust-analyzer" },
  filetypes = {"rust"},
  -- root_dir = lspconfig.util.root_pattern("Cargo.toml", "rust-project.json"),
  single_file_support = true,
  tools = { -- rust-tools options
    -- automatically set inlay hints (type hints)
    -- There is an issue due to which the hints are not applied on the first
    -- opened file. For now, write to the file to trigger a reapplication of
    -- the hints or just run :RustSetInlayHints.
    -- default: true
    autoSetHints = false,
  },
}

-- rust-tool
-- local opts = {
--   tools = { -- rust-tools options
--     -- automatically set inlay hints (type hints)
--     -- There is an issue due to which the hints are not applied on the first
--     -- opened file. For now, write to the file to trigger a reapplication of
--     -- the hints or just run :RustSetInlayHints.
--     -- default: true
--     autoSetHints = true,
--   },
-- }

-- return {
--   on_setup = function(server)
--     -- server:setup(opts)
    
--     -- Initialize the LSP via rust-tools instead
--     require("rust-tools").setup({
--       -- The "server" property provided in rust-tools setup function are the
--       -- settings rust-tools will provide to lspconfig during init.
--       -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
--       -- with the user's own settings (opts).
--       server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
--     })
--     server:attach_buffers()
--     -- Only if standalone support is needed
--     require("rust-tools").start_standalone_if_required()
--   end,
-- }

return opts