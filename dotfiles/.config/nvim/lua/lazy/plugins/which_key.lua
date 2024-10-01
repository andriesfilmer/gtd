return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  config = function()
    require("which-key").setup {
      icons = {
        separator = ' ',
        mappings = false, -- Disable icons for mappings
      },
    }

    local config = require("which-key")
    config.add({
      { "<leader>b", group = " [b]ufferline" },
      { "<leader>e", group = " [e]xplorer" },
      { "<leader>f", group = " [f]ormat keys" },
      { "<leader>n", group = " [n]umber & sign column keys" },
      { "<leader>s", group = " [s]ession keys" },
      { "<leader>g", group = " [g]it keys" },
      { "<leader>t", group = " [t]elescope keys" },
      { "<leader>v", group = " n[v]im config keys" },
    })
  end,
}
