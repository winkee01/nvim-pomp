---@diagnostic disable: undefined-global
return {
  s(
    {
      trig = 'eof',
      name = 'Create Heredoc',
      dscr = 'Create a heredoc',
    },
    require('luasnip.extras.fmt').fmt(
      [[
   EOF << lua
   {}
   EOF
   ]],
      { i(1) }
    )
  ),
}