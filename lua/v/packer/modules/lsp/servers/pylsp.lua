-- Install: pipx install 'python-lsp-server[all]'

local opts = {
  flags = {
    debounce_text_changes = 150,
  },
  cmd = { "pylsp" },
  filetypes = {"python"},
  settings = {
    pylsp = {
      plugins = {
        jedi_completion = {
          fuzzy = true,
          include_params = true,
        },
        flake8 = {
          enabled = true,
          hangClosing = false,
          maxLineLength = 160,
        },
        pyls_flake8 = {
          enabled = true,
          hangClosing = false,
          maxLineLength = 160,
        },
        pycodestyle = {
          hangClosing = false,
          maxLineLength = 160,
        },
        pydocstyle = {
          enabled = true,
          convention = 'numpy',
          ignore = pydocstyle_ignore,
          addIgnore = pydocstyle_ignore,
        },
        pylint = enable,
        rope = disable,
        pylsp_rope = disable,
        pylsp_mypy = enable,
        pyls_isort = disable,
        autopep8 = disable,
        black = disable,
        python_lsp_black = disable,
        pyls_black = disable,
        pylsp_black = disable,
      },
    },
  }
}

return opts