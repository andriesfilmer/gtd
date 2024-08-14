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
map("n", "<space>nr", "<cmd>set rnu!<CR>", { desc = " Toggle relative numbers" })

map("n", "<space>sn", "<cmd>set signcolumn=no<CR>", { desc = " Signcolumn off" }) -- hide git signs
map("n", "<space>sy", "<cmd>set signcolumn=yes<CR>", { desc = " Signcolumn on" }) -- show git signs

map("n", "<space>o", "<cmd>only<CR>", { desc = "Make window only one" })

map("n", "<CR><CR>", "<cmd>noh!<CR>", { desc = "Unset search pattern hitting return" })

--map('n', '<F3>', ":e $MYVIMRC<CR>", { desc = "Open my vimrc" })
map('n', '<C-F3>', ":e ~/gtd/dotfiles/.config/nvim/lua/keymaps.lua<CR>", { desc = "Open my keymaps" })
map('n', '<Ctrl><F4>', ":e ~/gtd/cheatsheets/vim.md<CR>", { desc = "Vim cheatsheet" })
map('n', '<C-F9>', ":set background=light<CR>", { desc = "Background light" })
map('n', '<C-F10>', ":set background=dark<CR>", { desc = "Background dark" })


