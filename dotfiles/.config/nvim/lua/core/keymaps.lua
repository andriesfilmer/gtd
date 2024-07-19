-- Shorten function name
local map = vim.keymap.set

-- Normal --
-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

-- Resize with arrows
map("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize window up" })
map("n", "<C-Down>", ":resize +2<CR>",{  desc = "Resize window down" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize window left" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize window right" })

-- Naviagate buffers
map("n", "<S-l>", ":bnext<CR>", { desc = "Buffer next" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Buffer previous" })

-- Move text up and down
map("n", "<A-j>", "<Esc>:m .+1<CR>==g", { desc = "Move text down" })
map("n", "<A-k>", "<Esc>:m .-2<CR>==g", {desc = "Move text up" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line numbers" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative numbers" })

map('n', '<leader><F2>', ":e ~/gtd/dotfiles/.config/nvim/lua/core/keymaps.lua<CR>", { desc = "Open my keymaps" })
map('n', '<leader><F4>', ":e ~/gtd/cheatsheets/vim.md<CR>", { desc = "Vim cheatsheet" })

-- Insert --
map("i", "jk", "<ESC>", { desc = "jk to insert mode" })

-- Visual --
-- Stay in indent mode
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move text up and down
map("v", "<A-j>", ":m .+1<CR>==", { desc = "Visual move text down" })
map("v", "<A-k>", ":m .-2<CR>==", { desc = "Visual move text up" })

-- Visual Block --
-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move text down" }) 
map("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move text up" })
map("x", "<A-j>", ":move '>+1<CR>gv-gv", { desc = "Move text down" })
map("x", "<A-k>", ":move '<-2<CR>gv-gv", { desc = "Move text down" })

-- Terminal --

-- Command --

-- PLUGINS --
-------------------------------------------------------------------------------
-- nvim-tree
--map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree explorer" })
map('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = "nvimtree toggle" })
map('n', '<leader>n', '<cmd>NvimTreeFindFile<CR>', { desc = "nvimtree focus file" })

-- https://github.com/mbbill/undotree
map('n', '<leader><F5>', vim.cmd.UndotreeToggle, { desc = "Open Undotree" })

-- Comment
-- map("n", "<leader>/", "gcc", { desc = "comment toggle", remap = true })
-- map("v", "<leader>/", "gc", { desc = "comment toggle", remap = true })

-- telescope
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


