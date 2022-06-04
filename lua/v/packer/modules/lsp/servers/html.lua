-- Install: npm i -g vscode-langservers-extracted

local filetypes = {
    'aspnetcorerazor',
    'blade',
    'django-html',
    'edge',
    'ejs',
    'eruby',
    'gohtml',
    'haml',
    'handlebars',
    'hbs',
    'html',
    'html-eex',
    'jade',
    'leaf',
    'liquid',
    -- 'markdown',
    'mdx',
    'mustache',
    'njk',
    'nunjucks',
    'php',
    'razor',
    'slim',
    'twig',
    'vue',
    'svelte',
}

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local opts = {
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  -- on_attach = function(client, bufnr)
  --   -- disable doc formatting, leave it to a specialized plugin
  --   client.resolved_capabilities.document_formatting = false
  --   client.resolved_capabilities.document_range_formatting = false

  --   local function buf_set_keymap(...)
  --     vim.api.nvim_buf_set_keymap(bufnr, ...)
  --   end
  --   -- require('keybindings_lsp').mapLSP(buf_set_keymap)
  --   -- auto format
  --   vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()')
  -- end,
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = filetypes,
  init_options = {
    configurationSection = { "html", "css", "javascript" },
    embeddedLanguages = {
      css = true,
      javascript = true
    },
    provideFormatter = true
  }
}

return opts