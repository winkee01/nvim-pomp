-- Install: npm i -g vscode-langservers-extracted

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local ok, res = v.safe_require('schemastore', {silent = true})

-- Schemas https://www.schemastore.org
local schemas = {
  {
    fileMatch = { "package.json" },
    url = "https://json.schemastore.org/package.json",
  },
  {
    fileMatch = { "tsconfig*.json" },
    url = "https://json.schemastore.org/tsconfig.json",
  },
  {
    fileMatch = {
        ".prettierrc",
        ".prettierrc.json",
        "prettier.config.json",
    },
    url = "https://json.schemastore.org/prettierrc.json",
  },
  {
    fileMatch = { ".eslintrc", ".eslintrc.json" },
    url = "https://json.schemastore.org/eslintrc.json",
  },
  {
    fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
    url = "https://json.schemastore.org/babelrc.json",
  },
  {
    fileMatch = { "lerna.json" },
    url = "https://json.schemastore.org/lerna.json",
  },
  {
    fileMatch = {
        ".stylelintrc",
        ".stylelintrc.json",
        "stylelint.config.json",
    },
    url = "http://json.schemastore.org/stylelintrc.json",
  },
  {
    fileMatch = { "/.github/workflows/*" },
    url = "https://json.schemastore.org/github-workflow.json",
  },
}

local opts = {
  capabilities = capabilities,
  settings = {
    json = {
      schemas = (ok and {res.json.schemas()} or {schemas})[1],
      -- schemas = schemas,
    },
  },
  flags = {
    debounce_text_changes = 150,
  },
  on_attach = function(client, bufnr)
    -- disable formatting, leave it to specialized formatting plugin
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
    local function buf_set_keymap(...)
      vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    -- local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    require("keybindings_lsp").mapLSP(buf_set_keymap)
  end,
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  init_options = { provideFormatter = true },
  root_dir = function(fname)
    return require'lspconfig'.util.find_git_ancestor(fname)
  end,
}

return opts
