-- formatting for lua
-- TODO: setup luacheck? https://github.com/mpeterv/luacheck
-- https://github.com/rockerBOO/dotfiles/blob/current/config/efm-langserver/config.yaml#L3-L4
-- TODO: setup CI w/ github actions (+ unit tests --> lua busted)
return {
    formatCommand = "stylua -s --stdin-filepath ${INPUT} -",
    formatStdin = true,
    rootMarkers = {
        '.stylua.toml',
    },
}