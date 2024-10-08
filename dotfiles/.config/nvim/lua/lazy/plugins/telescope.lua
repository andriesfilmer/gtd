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
    keymap.set('n', '<Leader>tf', builtin.find_files, { desc = 'Find [f]iles' })
    keymap.set("n", "<Leader>tr", "<cmd>Telescope oldfiles<cr>", { desc = "Find [r]ecent files" })
    keymap.set('n', '<Leader>ts', "<cmd>Telescope grep_string<cr>", { desc = 'Find [s]tring under cursor' })
    keymap.set('n', '<Leader>tg', builtin.live_grep, { desc = 'Live [g]rep' })
    keymap.set('n', '<Leader>tb', builtin.buffers, { desc = 'Find [b]uffers' })
    keymap.set('n', '<Leader>th', builtin.help_tags, { desc = 'Find [h]elp' })
    keymap.set("n", "<Leader>tk", "<cmd>Telescope keymaps<cr>", { desc = "Fuzzy find [k]eymaps" })
  end,
}
