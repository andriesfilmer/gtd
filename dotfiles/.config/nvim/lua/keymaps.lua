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
map('n', '<F3>', ":e $MYVIMRC<CR>", { desc = "Open my vimrc" })
map('n', '<F4>', ":e ~/gtd/cheatsheets/vim.md<CR>", { desc = "Vim cheatsheet" })


