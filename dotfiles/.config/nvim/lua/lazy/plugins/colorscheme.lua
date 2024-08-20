return {
  "folke/tokyonight.nvim",
  priority = 1000,
  config = function()
    vim.cmd("colorscheme tokyonight")
  end,
}

-- return {
--   "catppuccin/nvim",
--   as = "catppuccin",
--   config = function()
--     vim.cmd.colorscheme "catppuccin"
--   end
-- }
