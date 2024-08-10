require('which-key').setup({
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  icons = {
    mappings = false,
    rules = false,
  },
})
