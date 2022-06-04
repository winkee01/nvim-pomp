-- Install staticcheck
-- https://github.com/dominikh/go-tools
-- https://github.com/dominikh/go-tools/releases
return {
    lintCommand = "staticcheck",
    lintIgnoreExitCode = true,
    lintFormats = { "%f:%l:%c: %m" },
    lintSource = "staticcheck",
}
