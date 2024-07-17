local colors = {
  blue   = '#48898c',
  cyan   = '#79dac8',
  black  = '#141414',
  white  = '#c6c6c6',
  red    = '#ff5189',
  violet = '#b16286',
  grey   = '#303030',
  orange = "#e07016",
}

require('lualine').setup {
  options = {
    theme = {
      normal = {
        a = { fg = colors.black, bg = colors.blue },
        b = { fg = colors.white, bg = colors.grey },
        c = { fg = colors.black, bg = colors.black },
      },
      insert = { a = { fg = colors.black, bg = colors.red } },
      visual = { a = { fg = colors.black, bg = colors.violet } },
      replace = { a = { fg = colors.black, bg = colors.red } },
      inactive = {
        a = { fg = colors.white, bg = colors.black },
        b = { fg = colors.white, bg = colors.black },
        c = { fg = colors.black, bg = colors.black },
      },
    },
		normal = {
      a = { fg = colors.black, bg = colors.orange },
      icons_enabled = false,
      always_divide_middle = false,
		},
  },
  sections = {
    lualine_a = {
      'mode',
    },
    lualine_b = {'buffers'},
    lualine_c = {
      'diff',
    },
    lualine_x = {'location'},
    lualine_y = {'progress'},
    lualine_z = {'diff'},
  }
}
