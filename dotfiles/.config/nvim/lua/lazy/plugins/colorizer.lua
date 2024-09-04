return {
  "norcalli/nvim-colorizer.lua",
  config = function()
    require 'colorizer'.setup {
      css = { rgb_fn = true, hsl_fn = true },
      lua = { rgb_fn = true, hsl_fn = true },
      scss = { rgb_fn = true, hsl_fn = true },
      javascript = { rgb_fn = true, hsl_fn = true },
      html = { rgb_fn = true, hsl_fn = true, mode = 'foreground' },
    }
  end,
}
