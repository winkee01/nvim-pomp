return function()
  local null_ls = require('null-ls')
  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local completion = null_ls.builtins.completion
  local code_actions = null_ls.builtins.code_actions

  null_ls.setup({
    debounce = 150,
    on_attach = v.lsp.on_attach,
    sources = {
      formatting.stylua.with({
        condition = function(_utils)
          return v.executable('stylua') and _utils.root_has_file({ 'stylua.toml', '.stylua.toml' })
        end,
      }),
      formatting.prettier.with({
        filetypes = { 'html', 'json', 'yaml', 'graphql', 'markdown' },
        condition = function()
          return v.executable('prettier')
        end,
      }),
      formatting.black.with({ extra_args = { "--fast" } }), 
      formatting.rubocop, -- Ruby: gem install rubocop
      formatting.gofmt,
      formatting.shfmt,
      formatting.clang_format,
      formatting.cmake_format,
      formatting.dart_format,
      formatting.lua_format.with({
        extra_args = {
          '--no-keep-simple-function-one-line', '--no-break-after-operator', '--column-limit=100',
          '--break-after-table-lb', '--indent-width=2'
        }
      }),
      formatting.isort,
      formatting.codespell.with({filetypes = {'markdown'}}),
      -- formatting.fixjson,
      diagnostics.eslint.with({
        prefer_local = "node_modules/.bin",
      }),

      formatting.eslint_d,

      diagnostics.zsh,
      -- diagnostics.golangci_lint,
      diagnostics.eslint_d,
      diagnostics.flake8,
    -- diagnostics.markdownlint,
    -- markdownlint-cli2
    -- diagnostics.markdownlint.with({
    --   prefer_local = "node_modules/.bin",
    --   command = "markdownlint-cli2",
    --   args = { "$FILENAME", "#node_modules" },
    -- }),

      code_actions.gitsigns,
      code_actions.eslint_d,
      -- code_actions.eslint.with({
      --   prefer_local = "node_modules/.bin",
      -- }),
      -- code_actions.refactoring,

      completion.spell,
    },
    diagnostics_format = "[#{s}] #{m}",
    -- on_attach = 
  })
end