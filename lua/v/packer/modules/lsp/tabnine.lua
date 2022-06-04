return function()
  require('cmp_tabnine.config'):setup({
    max_lines                = 1000;
    max_num_results          = 3;
    sort                     = true;
    show_prediction_strength = true;
    run_on_every_keystroke   = true;
    snipper_placeholder      = '..';
    ignored_file_types       = {};
  })
end