require('lualine').setup {
  options = {
    theme = 'nightfly',
    icons_enabled = false,
    always_divide_middle = false,
  },
  sections = {
    lualine_a = {'buffers'},
    lualine_b = {'diff'},
    lualine_c = {},
    lualine_x = {'location'},
    lualine_y = {'progress'},
    lualine_z = {'diff'},
  }
}
