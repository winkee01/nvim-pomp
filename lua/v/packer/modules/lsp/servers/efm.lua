-- https://github.com/mattn/efm-langserver

local vint = require "plugins-config/lsp/efm/vint"
local stylua = require "plugins-config/lsp/efm/stylua"
local luacheck = require "plugins-config/lsp/efm/luacheck"
local staticcheck = require "plugins-config/lsp/efm/staticcheck"
local go_vet = require "plugins-config/lsp/efm/go_vet"
local goimports = require "plugins-config/lsp/efm/goimports"
local gofmt = require "plugins-config/lsp/efm/gofmt"
local black = require "plugins-config/lsp/efm/black"
local isort = require "plugins-config/lsp/efm/isort"
local flake8 = require "plugins-config/lsp/efm/flake8"
local mypy = require "plugins-config/lsp/efm/mypy"
local prettier = require "plugins-config/lsp/efm/prettier"
local prettierd = require "plugins-config/lsp/efm/prettierd"
local eslint_d = require "plugins-config/lsp/efm/eslint_d"
local shellcheck = require "plugins-config/lsp/efm/shellcheck"
local shfmt = require "plugins-config/lsp/efm/shfmt"
local terraform = require "plugins-config/lsp/efm/terraform"
local misspell = require "plugins-config/lsp/efm/misspell"
local rustfmt = require "plugins-config/lsp/efm/rustfmt"
local sqlint = require "plugins-config/lsp/efm/sqlint"

local opts = {
  capabilities = v.lsp.capabilities,
  -- on_attach = NvimMax.on_attach,
  -- cmd = { "/usr/local/bin/efm-langserver" },
  init_options = { 
    documentFormatting = true,
    documentSymbol = true,
    hover = true,
    codeAction = true,
    completion = false,
  },
  root_dir = vim.loop.cwd,
  settings = {
    version = 2,
    rootMarkers = {
      '.git/'
      '.eslintrc.cjs',
      '.eslintrc.js',
      '.eslintrc.json',
      '.eslintrc.ts',
      '.eslintrc.yaml',
      '.eslintrc.yml',
      '.git/',
      '.prettierrc',
      '.prettierrc.json',
      '.sqlintrc.json',
      '.stylua.toml',
      'package.json',
      'requirements.txt',
    },
    lintDebounce = 100,
    logLevel = 5,
    logFile = '/tmp/efm.log',
    languages = {
      -- ["="] = { misspell },
      lua = { stylua, luacheck },
      go = { staticcheck, goimports, go_vet, gofmt },
      python = { black, isort, flake8, mypy },
      typescript = { prettierd, eslint_d },
      javascript = { prettierd, eslint_d },
      typescriptreact = { prettierd, eslint_d },
      javascriptreact = { prettierd, eslint_d },
      yaml = { prettierd },
      json = { prettierd },
      html = { prettierd },
      scss = { prettierd },
      css = { prettierd },
      markdown = { prettier },
      graphql = { prettierd },
      sql = { sqlint },
      sh = { shellcheck, shfmt },
      terraform = { terraform },
      rust = { rustfmt },
      vim = { vint },
    },
  },
  filetypes = {
    'css',
    'cpp',
    'html',
    'javascript',
    'javascript.jsx',
    'javascriptreact',
    'json',
    'lua',
    'go',
    'python',
    'rust',
    'scss',
    'sql',
    'typescript',
    'typescript.tsx',
    'typescriptreact',
    'vim',
    'yaml',
  },
}

return opts