-- Shorten function name
local map = vim.keymap.set

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

map("n", "<space>n", "<cmd>set nu!<CR>", { desc = " Toggle line numbers" })

map("n", "<space>sn", "<cmd>set signcolumn=no<CR>", { desc = " Signcolumn off" }) -- hide git signs
map("n", "<space>sy", "<cmd>set signcolumn=yes<CR>", { desc = " Signcolumn on" }) -- show git signs

map("n", "<space>o", "<cmd>only<CR>", { desc = "Make window only one" })

map("n", "<space>h", "<cmd>nohlsearch<CR>", { desc = "No highlite search" })

map('n', '<space>cn', ":e $MYVIMRC<CR>:NvimTreeFindFile!<CR>", { desc = "My Nvim config" })
map('n', '<space>ch', ":e ~/gtd/cheatsheets/vim.md<CR>", { desc = "Vim cheatsheet" })
map('n', '<space>bl', ":set background=light<CR>", { desc = "Background light" })
map('n', '<space>bd', ":set background=dark<CR>", { desc = "Background dark" })

