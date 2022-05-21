-- source https://superuser.com/a/540519
-- write the visual selection to the filename passed in as a command argument then delete the
-- selection placing into the black hole register
v.command('MoveWrite', [[<line1>,<line2>write<bang> <args> | <line1>,<line2>delete _]], {
  nargs = 1,
  bang = true,
  range = true,
  complete = 'file',
})
v.command('MoveAppend', [[<line1>,<line2>write<bang> >> <args> | <line1>,<line2>delete _]], {
  nargs = 1,
  bang = true,
  range = true,
  complete = 'file',
})