return {
    lintCommand = "eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}",
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = {
        "%f(%l,%c): %tarning %m",
        "%f(%l,%c): %rror %m",
    },
    formatCommand = 'eslint_d -f visualstudio --fix-to-stdout --stdin --stdin-filename=${INPUT}',
    formatStdin = true,
    lintSource = "eslint_d",
    rootMarkers = {
        '.eslintrc.cjs',
        '.eslintrc.js',
        '.eslintrc.ts',
        '.eslintrc.yaml',
        '.eslintrc.yml',
        '.eslintrc.json',
        'package.json',
    },
}
