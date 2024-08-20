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
    keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Find recent files" })
    keymap.set('n', '<leader>fc', "<cmd>Telescope grep_string<cr>", { desc = 'Find string under cursor' })
    keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
    keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
    keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find help' })
    keymap.set("n", "<leader>fy", "<cmd>Telescope keymaps<cr>", { desc = "Fuzzy find keymaps" })
  end,
}
