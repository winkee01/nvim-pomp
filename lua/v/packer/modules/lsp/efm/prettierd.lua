-- formatting for js/ts/json/yaml/html/css, etc
local prettierd = {
    formatCommand = ([[
        $([ -n "$(command -v node_modules/.bin/prettier)" ] && echo "node_modules/.bin/prettier" || echo "prettierd")
        "${INPUT}"
    ]]):gsub('\n', ' '),

    formatStdin = true,
    rootMarkers = {
        '.prettierrc',
        '.prettierrc.json',
        'package.json',
    },

    env = {
        string.format('PRETTIERD_DEFAULT_CONFIG=%s', vim.fn.expand('~/.prettierrc.json')),
    },
}