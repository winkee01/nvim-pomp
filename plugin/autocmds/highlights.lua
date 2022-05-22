local H = require('v.utils.highlights')

local fmt = string.format
local fn = vim.fn
local api = vim.api
local P = v.style.palette
local L = v.style.lsp.colors
local levels = vim.log.levels

local function set_hi_sidebar()
  local normal_bg = H.get_hl('Normal', 'bg')
  local split_color = H.get_hl('VertSplit', 'fg')
  local bg_color = H.alter_color(normal_bg, -8)
  local st_color = H.alter_color(H.get_hl('Visual', 'bg'), -20)
  H.set_hi_all({
    PanelBackground = { background = bg_color },
    PanelHeading = { background = bg_color, bold = true },
    PanelVertSplit = { foreground = split_color, background = bg_color },
    PanelWinSeparator = { foreground = split_color, background = bg_color },
    PanelStNC = { background = bg_color, foreground = split_color },
    PanelSt = { background = st_color },
  })
end

local sidebar_fts = {
  'packer',
  'flutterToolsOutline',
  'undotree',
  'neo-tree',
  'Outline',
}

local function on_sidebar_enter()
  vim.wo.winhighlight = table.concat({
    'Normal:PanelBackground',
    'EndOfBuffer:PanelBackground',
    'StatusLine:PanelSt',
    'StatusLineNC:PanelStNC',
    'SignColumn:PanelBackground',
    'VertSplit:PanelVertSplit',
    'WinSeparator:PanelWinSeparator',
  }, ',')
end

local function general_overrides()
  local comment_fg = H.get_hl('Comment', 'fg')
  local keyword_fg = H.get_hl('Keyword', 'fg')
  local normal_bg = H.get_hl('Normal', 'bg')
  local code_block = H.alter_color(normal_bg, 30)
  local msg_area_bg = H.alter_color(normal_bg, -10)
  local hint_line = H.alter_color(L.hint, -70)
  local error_line = H.alter_color(L.error, -80)
  local warn_line = H.alter_color(L.warn, -80)
  H.set_hi_all({
    VertSplit = { background = 'NONE', foreground = { from = 'NonText' } },
    WinSeparator = { background = 'NONE', foreground = { from = 'NonText' } },
    mkdLineBreak = { link = 'NONE' },
    Directory = { inherit = 'Keyword', bold = true },
    URL = { inherit = 'Keyword', underline = true },
    -----------------------------------------------------------------------------//
    -- Commandline
    -----------------------------------------------------------------------------//
    MsgArea = { background = msg_area_bg },
    MsgSeparator = { foreground = comment_fg, background = msg_area_bg },
    -----------------------------------------------------------------------------//
    -- Floats
    -----------------------------------------------------------------------------//
    NormalFloat = { inherit = 'Pmenu' },
    FloatBorder = { inherit = 'NormalFloat', foreground = { from = 'NonText' } },
    CodeBlock = { background = code_block },
    markdownCode = { background = code_block },
    markdownCodeBlock = { background = code_block },
    -----------------------------------------------------------------------------//
    CursorLineNr = { bold = true },
    FoldColumn = { background = 'background' },
    Folded = { inherit = 'Comment', italic = true, bold = true },
    TermCursor = { ctermfg = 'green', foreground = 'royalblue' },
    -- Add undercurl to existing spellbad highlight
    SpellBad = { undercurl = true, background = 'NONE', foreground = 'NONE', sp = 'green' },
    SpellRare = { undercurl = true },
    PmenuSbar = { background = P.grey },
    -----------------------------------------------------------------------------//
    -- Diff
    -----------------------------------------------------------------------------//
    DiffAdd = { background = '#26332c', foreground = 'NONE' },
    DiffDelete = { background = '#572E33', foreground = '#5c6370' },
    DiffChange = { background = '#273842', foreground = 'NONE' },
    DiffText = { background = '#314753', foreground = 'NONE' },
    diffAdded = { link = 'DiffAdd' },
    diffChanged = { link = 'DiffChange' },
    diffRemoved = { link = 'DiffDelete' },
    diffBDiffer = { link = 'WarningMsg' },
    diffCommon = { link = 'WarningMsg' },
    diffDiffer = { link = 'WarningMsg' },
    diffFile = { link = 'Directory' },
    diffIdentical = { link = 'WarningMsg' },
    diffIndexLine = { link = 'Number' },
    diffIsA = { link = 'WarningMsg' },
    diffNoEOL = { link = 'WarningMsg' },
    diffOnly = { link = 'WarningMsg' },
    -----------------------------------------------------------------------------//
    -- colorscheme overrides
    -----------------------------------------------------------------------------//
    Comment = { italic = true },
    Type = { italic = true, bold = true },
    Include = { italic = true, bold = false },
    QuickFixLine = { inherit = 'PmenuSbar', foreground = 'NONE', italic = true },
    -- Neither the sign column or end of buffer highlights require an explicit background
    -- they should both just use the background that is in the window they are in.
    -- if either are specified this can lead to issues when a winhighlight is set
    SignColumn = { background = 'NONE' },
    EndOfBuffer = { background = 'NONE' },
    MatchParen = {
      background = 'NONE',
      foreground = 'NONE',
      bold = false,
      underlineline = true,
      sp = 'white',
    },
    -----------------------------------------------------------------------------//
    -- Treesitter
    -----------------------------------------------------------------------------//
    TSNamespace = { link = 'TypeBuiltin' },
    TSKeywordReturn = { italic = true, foreground = keyword_fg },
    TSParameter = { italic = true, bold = true, foreground = 'NONE' },
    TSError = { undercurl = true, sp = error_line, foreground = 'NONE' },
    -- highlight FIXME comments
    commentTSWarning = { background = P.light_red, foreground = 'fg', bold = true },
    commentTSDanger = { background = L.hint, foreground = '#1B2229', bold = true },
    commentTSNote = { background = L.info, foreground = '#1B2229', bold = true },
    -----------------------------------------------------------------------------//
    -- LSP
    -----------------------------------------------------------------------------//
    LspCodeLens = { link = 'NonText' },
    LspReferenceText = { underline = true, background = 'NONE' },
    LspReferenceRead = { underline = true, background = 'NONE' },
    -- This represents when a reference is assigned which is more interesting than regular
    -- occurrences so should be highlighted more distinctly
    LspReferenceWrite = { underline = true, bold = true, italic = true, background = 'NONE' },
    DiagnosticHint = { foreground = L.hint },
    DiagnosticError = { foreground = L.error },
    DiagnosticWarning = { foreground = L.warn },
    DiagnosticInfo = { foreground = L.info },
    DiagnosticUnderlineError = { undercurl = true, sp = L.error, foreground = 'none' },
    DiagnosticUnderlineHint = { undercurl = true, sp = L.hint, foreground = 'none' },
    DiagnosticUnderlineWarn = { undercurl = true, sp = L.warn, foreground = 'none' },
    DiagnosticUnderlineInfo = { undercurl = true, sp = L.info, foreground = 'none' },
    DiagnosticSignHintLine = { background = hint_line },
    DiagnosticSignErrorLine = { background = error_line },
    DiagnosticSignWarnLine = { background = warn_line },
    DiagnosticSignHintNr = {
      inherit = 'DiagnosticSignHintLine',
      foreground = { from = 'Normal' },
      bold = true,
    },
    DiagnosticSignErrorNr = {
      inherit = 'DiagnosticSignErrorLine',
      foreground = { from = 'Normal' },
      bold = true,
    },
    DiagnosticSignWarnNr = {
      inherit = 'DiagnosticSignWarnLine',
      foreground = { from = 'Normal' },
      bold = true,
    },
    DiagnosticSignWarn = { link = 'DiagnosticWarn' },
    DiagnosticSignInfo = { link = 'DiagnosticInfo' },
    DiagnosticSignHint = { link = 'DiagnosticHint' },
    DiagnosticSignError = { link = 'DiagnosticError' },
    DiagnosticFloatingWarn = { link = 'DiagnosticWarn' },
    DiagnosticFloatingInfo = { link = 'DiagnosticInfo' },
    DiagnosticFloatingHint = { link = 'DiagnosticHint' },
    DiagnosticFloatingError = { link = 'DiagnosticError' },
  })
end

local function colorscheme_overrides()
  if vim.g.colors_name == 'doom-one' then
    H.set_hi_all({
      CursorLineNr = { foreground = { from = 'Keyword' } },
      LineNr = { background = 'NONE' },
    })
  end
end

local function set_hi_user()
  general_overrides()
  colorscheme_overrides()
  set_hi_sidebar()
end

v.augroup('UserHighlights', {
  {
    event = 'ColorScheme',
    command = function()
      set_hi_user()
    end,
  },
  {
    event = 'FileType',
    pattern = sidebar_fts,
    command = function()
      on_sidebar_enter()
    end,
  },
})

