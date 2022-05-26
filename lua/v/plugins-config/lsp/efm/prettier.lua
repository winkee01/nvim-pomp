-- formatting for js/ts/json/yaml/html/css, etc
return {
    formatCommand = [[
        $([ -n "$(command -v node_modules/.bin/prettier)" ] && echo "node_modules/.bin/prettier" || echo "prettier") 
        --stdin-filepath ${INPUT} ${--config-precedence:configPrecedence} ${--tab-width:tabWidth} ${--single-quote:singleQuote} ${--trailing-comma:trailingComma}]]:gsub('\n', ' '),
    formatStdin = true,
    rootMarkers = {
        '.prettierrc',
        '.prettierrc.json',
        'package.json',
    },
}