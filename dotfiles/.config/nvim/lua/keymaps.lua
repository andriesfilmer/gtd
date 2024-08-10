-- Shorten function name
local map = vim.keymap.set

map('n', '<C-n>', '<cmd>Lex 30<CR>', { desc = "Toggle file exporer (Netrw)" })

map("n", "<C-Left>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-Right>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-Down>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-Up>", "<C-w>k", { desc = "switch window up" })

map("n", "<A-Up>", ":resize -2<CR>", { desc = "Resize window up" })
map("n", "<A-Down>", ":resize +2<CR>",{  desc = "Resize window down" })
map("n", "<A-Left>", ":vertical resize -2<CR>", { desc = "Resize window left" })
map("n", "<A-Right>", ":vertical resize +2<CR>", { desc = "Resize window right" })

map("n", "<tab>", ":bnext<CR>", { desc = "Buffer next" })
map("n", "<S-tab>", ":bprevious<CR>", { desc = "Buffer previous" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line numbers" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative numbers" })

map("n", "<CR><CR>", "<cmd>noh!<CR>", { desc = "Unset search pattern hitting return" })

-- map('n', '<leader><F3>', ":e ~/gtd/dotfiles/.config/nvim/lua/keymaps.lua<CR>", { desc = "Open my keymaps" })
map('n', '<leader><F3>', ":e $MYVIMRC<CR>", { desc = "Open my vimrc" })
map('n', '<leader><F4>', ":e ~/gtd/cheatsheets/vim.md<CR>", { desc = "Vim cheatsheet" })

-- PLUGINS --
-- ----------------------------------------------------------------------------
-- https://github.com/mbbill/undotree
map('n', '<leader><F5>', vim.cmd.UndotreeToggle, { desc = "Open Undotree" })

-- https://github.com/nvim-tree/nvim-tree.lua
map("n", "<leader>n", "<cmd>NvimTreeToggle<CR>", { desc = "NvimTree Toggle" })

-- https://github.com/nvim-telescope/telescope.nvim
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Telescope find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Telescope help page" })
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "Telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope find in current buffer" })
map("n", "<leader>fc", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>fs", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>ft", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })


