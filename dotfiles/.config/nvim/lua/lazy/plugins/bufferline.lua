return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
    options = {
      -- max_name_length = 18,
      -- max_prefix_length = 15,
      truncate_names = false,
      buffer_close_icon = false,
      modified_icon = '!',
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          highlight = "Directory",
          separator = true,
          text_align = "left",
        },
      },
    },
  },
}
