v.create_command('ReloadModule', function(tbl)
  require('plenary.reload').reload_module(tbl.args)
end, {
  nargs = 1,
})