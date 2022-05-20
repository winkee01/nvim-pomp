local fn = vim.fn
-----------------------------------------------------------------------------//
-- Message output on vim actions {{{1
-----------------------------------------------------------------------------//
vim.opt.shortmess = {
  t = true, -- truncate file messages at start
  A = true, -- ignore annoying swap file messages
  o = true, -- file-read message overwrites previous
  O = true, -- file-read message overwrites previous
  T = true, -- truncate non-file messages in middle
  f = true, -- (file x of x) instead of just (x of x
  F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
  s = true,
  c = true,
  W = true, -- Don't show [w] or written when writing
}
-----------------------------------------------------------------------------//
-- Timings {{{1
-----------------------------------------------------------------------------//
vim.opt.updatetime = 300
vim.opt.timeout = true
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10
-----------------------------------------------------------------------------//
-- Window splitting and buffers {{{1
-----------------------------------------------------------------------------//
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.eadirection = 'hor'
-- exclude usetab as we do not want to jump to buffers in already open tabs
-- do not use split or vsplit to ensure we don't open any new windows
vim.o.switchbuf = 'useopen,uselast'
vim.opt.fillchars = { -- Chars to fill the statuslines and vertical separators
  fold = ' ',
  eob = ' ', -- suppress ~ at EndOfBuffer
  diff = '╱', -- alternatives = ⣿ ░ ─
  msgsep = ' ', -- alternatives: ‾ ─
  foldopen = '▾',
  foldsep = '│',
  foldclose = '▸',
}

-- set.fillchars = {
--     diff = '∙', -- BULLET OPERATOR (U+2219, UTF-8: E2 88 99)
--     eob = ' ', -- NO-BREAK SPACE (U+00A0, UTF-8: C2 A0) to suppress ~ at EndOfBuffer
--     fold = '·', -- MIDDLE DOT (U+00B7, UTF-8: C2 B7)
--     vert = ' ' -- remove ugly vertical lines on window division
-- }
-----------------------------------------------------------------------------//
-- Diff {{{1
-----------------------------------------------------------------------------//
-- Use in vertical diff mode, blank lines to keep sides aligned, Ignore whitespace changes
vim.opt.diffopt = vim.opt.diffopt
  + {
    'vertical',
    'iwhite',
    'hiddenoff',
    'closeoff', -- turn off diff when one file window is closed
    'foldcolumn:0',
    'context:4',
    'algorithm:histogram',
    'indent-heuristic',
    'internal',
    'filler', -- show filler for deleted lines
  }
-----------------------------------------------------------------------------//
-- Format Options {{{1
-----------------------------------------------------------------------------//
vim.opt.formatoptions = {
  ['1'] = true,
  ['2'] = true, -- Use indent from 2nd line of a paragraph
  q = true, -- continue comments with gq"
  c = true, -- Auto-wrap comments using textwidth
  r = true, -- Continue comments when pressing Enter
  n = true, -- Recognize numbered lists
  t = false, -- autowrap lines using text width value
  j = true, -- remove a comment leader when joining lines.
  -- Only break if the line was not longer than 'textwidth' when the insert
  -- started and only at a white character that has been entered during the
  -- current insert command.
  l = true,
  v = true,
}

-- Correctly break multi-byte characters such as CJK,
-- see https://stackoverflow.com/q/32669814/6064933
-- set.formatoptions = set.formatoptions + 'mM'

-----------------------------------------------------------------------------//
-- Folds {{{1
-----------------------------------------------------------------------------//
vim.opt.foldtext = 'v:lua.v.folds()'
vim.opt.foldopen = vim.opt.foldopen + 'search'
vim.opt.foldlevelstart = 3
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldmethod = 'expr'
-----------------------------------------------------------------------------//
-- Quickfix {{{1
-----------------------------------------------------------------------------//
--- FIXME: Need to use a lambda rather than a lua function directly
--- @see https://github.com/neovim/neovim/pull/14886
-- vim.o.quickfixtextfunc = '{i -> v:lua.as.qftf(i)}'
-----------------------------------------------------------------------------//
-- Grepprg {{{1
-----------------------------------------------------------------------------//
-- Use faster grep alternatives if possible
if v.executable('rg') then
  vim.o.grepprg = [[rg --glob "!.git" --no-heading --vimgrep --follow $*]]
  vim.opt.grepformat = vim.opt.grepformat ^ { '%f:%l:%c:%m' }
elseif v.executable('ag') then
  vim.o.grepprg = [[ag --nogroup --nocolor --vimgrep]]
  vim.opt.grepformat = vim.opt.grepformat ^ { '%f:%l:%c:%m' }
end
-----------------------------------------------------------------------------//
-- Wild and file globbing stuff in command mode {{{1
-----------------------------------------------------------------------------//
vim.opt.wildcharm = fn.char2nr(v.replace_termcodes([[<Tab>]]))
vim.opt.wildmode = 'longest:full,full' -- Shows a menu bar as opposed to an enormous list
vim.opt.wildignorecase = true -- Ignore case when completing file names and directories
-- Binary
vim.opt.wildignore = {
  '*.aux',
  '*.out',
  '*.toc',
  '*.o',
  '*.obj',
  '*.dll',
  '*.jar',
  '*.pyc',
  '*.rbc',
  '*.class',
  '*.gif',
  '*.ico',
  '*.jpg',
  '*.jpeg',
  '*.png',
  '*.avi',
  '*.wav',
  -- Temp/System
  '*.*~',
  '*~ ',
  '*.swp',
  '.lock',
  '.DS_Store',
  'tags.lock',
}
vim.opt.wildoptions = 'pum'
vim.opt.pumblend = 3 -- Make popup window translucent

-- completion options
vim.opt.completeopt = 'menuone,noselect,noinsert'
--vim.opt.completeopt:remove({'preview'})  -- Disable the preview window
vim.opt.complete:append({'kspell'}) 
-- vim.opt.complete:remove({'w'})
-- vim.opt.complete:remove({'b'})
-- vim.opt.complete:remove({'u'})
-- vim.opt.complete:remove({'t'})

-- dictionary completion source (macOS)
-- Note: Since we use plugin (cmp-look) to handle this, no need to set here
-- vim.opt.dictionary = '/usr/share/dict/words'

-----------------------------------------------------------------------------//
-- Display {{{1
-----------------------------------------------------------------------------//
vim.opt.conceallevel = 2
vim.opt.breakindentopt = 'sbr'
vim.opt.linebreak = true -- lines wrap at words rather than random characters
vim.opt.synmaxcol = 1024 -- don't syntax highlight long lines
vim.opt.signcolumn = 'auto:2-5'
vim.opt.ruler = false
vim.opt.cmdheight = 2 -- Set command line height to two lines
vim.opt.showbreak = [[↪ ]] -- Options include -> '…', '↳ ', '→','↪ '
--- This is used to handle markdown code blocks where the language might
--- be set to a value that isn't equivalent to a vim filetype
vim.g.markdown_fenced_languages = {
  'js=javascript',
  'ts=typescript',
  'shell=sh',
  'bash=sh',
  'console=sh',
}
-----------------------------------------------------------------------------//
-- List chars {{{1
-----------------------------------------------------------------------------//
vim.opt.list = true -- show invisible chars (e.g. whitespace)
vim.opt.listchars = {
  eol = nil,
  space = ' ',
  tab = '▷─', -- WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7) + BOX DRAWINGS HEAVY TRIPLE DASH HORIZONTAL (U+2505, UTF-8: E2 94 85)
  nbsp = '⦸', -- CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
  extends = '»', -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
  precedes = '«', -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
  trail = '•', -- BULLET (U+2022, UTF-8: E2 80 A2)
}
-----------------------------------------------------------------------------//
-- Indent
-----------------------------------------------------------------------------//
vim.opt.wrap = true
vim.opt.wrapmargin = 2
vim.opt.textwidth = 80
vim.opt.autoindent = true
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
-----------------------------------------------------------------------------//
-- vim.o.debug = "msg"
vim.opt.gdefault = true
vim.opt.pumheight = 15
vim.opt.confirm = true -- make vim prompt me to save before doing destructive things
vim.opt.hlsearch = true
vim.opt.autowriteall = true -- automatically :write before running commands and changing files
-- vim.opt.clipboard = { 'unnamedplus' }
-- vim.opt.clipboard = vim.opt.clipboard + "unnamedplus"
vim.opt.laststatus = 3

-- GUI color/font/cursor/emoji
vim.opt.termguicolors = true
vim.opt.guifont = 'Fira Code Regular Nerd Font Complete Mono:h14'
-----------------------------------------------------------------------------//
-- Emoji {{{1
-----------------------------------------------------------------------------//
-- emoji is true by default but makes (n)vim treat all emoji as double width
-- which breaks rendering so we turn this off.
-- CREDIT: https://www.youtube.com/watch?v=F91VWOelFNE
vim.opt.emoji = false
-----------------------------------------------------------------------------//
-- Cursor {{{1
-----------------------------------------------------------------------------//
-- Set up cursor color and shape in various mode, ref:
-- https://github.com/neovim/neovim/wiki/FAQ#how-to-change-cursor-color-in-the-terminal

-- it enables mode shapes, "Cursor" highlight, and blinking
vim.opt.guicursor = {
  [[n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50]],
  -- [[a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor]], -- Cursor blink
  [[sm:block-blinkwait175-blinkoff150-blinkon175]],
}

vim.opt.cursorlineopt = 'screenline,number'
-----------------------------------------------------------------------------//
-- Title {{{1
-----------------------------------------------------------------------------//
function v.modified_icon()
  return vim.bo.modified and v.style.icons.misc.circle or ''
end
vim.opt.titlestring = ' ❐ %{fnamemodify(getcwd(), ":t")} %{v:lua.v.modified_icon()}'
vim.opt.titleold = fn.fnamemodify(vim.loop.os_getenv('SHELL'), ':t')
vim.opt.title = true
vim.opt.titlelen = 70
-----------------------------------------------------------------------------//
-- Utilities {{{1
-----------------------------------------------------------------------------//
vim.opt.showmode = false
vim.opt.sessionoptions = {
  'globals',
  'buffers',
  'curdir',
  'help',
  'winpos',
  -- "tabpages",
}
vim.opt.viewoptions = { 'cursor', 'folds' } -- save/restore just these (with `:{mk,load}view`)
vim.opt.virtualedit = 'block' -- allow cursor to move where there is no text in visual block mode
-------------------------------------------------------------------------------
-- BACKUP AND SWAPS {{{
-------------------------------------------------------------------------------
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.swapfile = false
--}}}
-----------------------------------------------------------------------------//
-- Match and search {{{1
-----------------------------------------------------------------------------//
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true -- Searches wrap around the end of the file
vim.opt.scrolloff = 9
vim.opt.sidescrolloff = 10
vim.opt.sidescroll = 1
-----------------------------------------------------------------------------//
-- Spelling {{{1
-----------------------------------------------------------------------------//
vim.opt.spellsuggest:prepend({ 12 })
vim.opt.spelloptions = 'camel'
vim.opt.spellcapcheck = '' -- don't check for capital letters at start of sentence
vim.opt.fileformats = { 'unix', 'mac', 'dos' }
vim.opt.spelllang:append('programming')
-----------------------------------------------------------------------------//
-- Mouse {{{1
-----------------------------------------------------------------------------//
-- vim.opt.mouse = 'a'
-- vim.opt.mousefocus = true
-----------------------------------------------------------------------------//
-- these only read ".vim" files
vim.opt.secure = true -- Disable autocmd etc for project local vimrc files.
vim.opt.exrc = true -- Allow project local vimrc files example .nvimrc see :h exrc
-----------------------------------------------------------------------------//
-- Git editor
-----------------------------------------------------------------------------//
if v.executable('nvr') then
  vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
  vim.env.EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
end

-- add a default colorscheme to avoid errors in highlight.lua
vim.cmd('colorscheme blue')
