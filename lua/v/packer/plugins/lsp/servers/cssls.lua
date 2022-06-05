-- Install: npm i -g vscode-langservers-extracted

--Enable (broadcasting) snippet capability for completion
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

local opts = {
  capabilities = capabilities,
  settings = {
    css = {
      validate = true
    },
    less = {
      validate = true
    },
    scss = {
      validate = true
    }
  },
  flags = {
    debounce_text_changes = 150,
  },
  -- on_attach = function(client, bufnr)
  --   -- disable formatting, leave it to specialized formatting plugin
  --   client.server_capabilities.document_formatting = false
  --   client.server_capabilities.document_range_formatting = false
  --   local function buf_set_keymap(...)
  --     vim.api.nvim_buf_set_keymap(bufnr, ...)
  --   end
  --   -- local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  --   require("keybindings_lsp").mapLSP(buf_set_keymap)
  -- end,
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" }
}

return {
  on_setup = function(server)
    server:setup(opts)
  end,
}
