v.augroup('VimrcIncSearchHighlight', {
  {
    -- automatically highlight search pattern once entering the commandline
    event = { 'CmdlineEnter' },
    targets = { '[/\\?]' },
    command = ':set hlsearch  | redrawstatus',
  },
  {
    -- automatically clear search highlight once leaving the commandline
    event = { 'CmdlineLeave' },
    targets = { '[/\\?]' },
    command = ':set nohlsearch | redrawstatus',
  },
})