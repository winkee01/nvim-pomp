-- linting for sql
local sqlint = {
    lintCommand = 'sqlint -f stylish --stdin',
    lintStdin = true,
    lintFormats = {
        '%f(%l:%c) %tarning %m',
        '%f(%l:%c) %rror %m',
    },
    lintIgnoreExitCode = true,
    formatCommand = 'sqlint -f stylish --stdin --fix',
    formatStdin = true,
    lintSource = 'sqlint',
    rootMarkers = {
        '.sqlintrc.json',
        'package.json',
    },
}