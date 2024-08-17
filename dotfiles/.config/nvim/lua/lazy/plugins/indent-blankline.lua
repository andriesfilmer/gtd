return {
  "lukas-reineke/indent-blankline.nvim",
  enabled = false, -- temporarily disabled
  event = { "BufReadPre", "BufNewFile" },
  main = "ibl",
  opts = {
    indent = { char = "┊" },
  },
}
