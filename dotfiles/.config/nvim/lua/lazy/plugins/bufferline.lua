return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
    options = {
      numbers = 'buffer_id',
      indicator = {
        style = 'underline',
      },
      buffer_close_icon = false,
      modified_icon = '!'
    },
  },
}
