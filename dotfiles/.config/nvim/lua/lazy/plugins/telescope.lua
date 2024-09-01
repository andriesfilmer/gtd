return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")

    telescope.load_extension("fzf")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness
    local builtin = require('telescope.builtin')
    keymap.set('n', '<Leader>tf', builtin.find_files, { desc = 'Find files' })
    keymap.set("n", "<Leader>tr", "<cmd>Telescope oldfiles<cr>", { desc = "Find recent files" })
    keymap.set('n', '<Leader>tc', "<cmd>Telescope grep_string<cr>", { desc = 'Find string under cursor' })
    keymap.set('n', '<Leader>tg', builtin.live_grep, { desc = 'Live grep' })
    keymap.set('n', '<Leader>tb', builtin.buffers, { desc = 'Find buffers' })
    keymap.set('n', '<Leader>th', builtin.help_tags, { desc = 'Find help' })
    keymap.set("n", "<Leader>ty", "<cmd>Telescope keymaps<cr>", { desc = "Fuzzy find keymaps" })
  end,
}
