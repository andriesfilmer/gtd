vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Shorten function name
local map = vim.keymap.set

-- Switch wiondows
map("n", "<C-Left>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-Right>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-Down>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-Up>", "<C-w>k", { desc = "switch window up" })

-- Resize windows
map("n", "<A-Up>", ":resize -2<cr>", { desc = "Resize window up" })
map("n", "<A-Down>", ":resize +2<cr>", { desc = "Resize window down" })
map("n", "<A-Left>", ":vertical resize -2<cr>", { desc = "Resize window left" })
map("n", "<A-Right>", ":vertical resize +2<cr>", { desc = "Resize window right" })

-- Buffers and tabs
map("n", "<Tab>", ":bnext<cr>", { desc = "Buffer next" })
map("n", "<S-Tab>", ":bprevious<cr>", { desc = "Buffer previous" })
map("n", "<A-w>", ":NvimTreeClose<cr>:bdelete<cr>", { desc = "Buffer delete" })
map("n", "<leader><Up>", ":%bd|e#|bd#<cr>", { desc = "Close bufs/tabs except current" })
map("n", "<leader><Left>", ":tabnext<cr>", { desc = "Tab next" })
map("n", "<leader><Right>", ":tabprevious<cr>", { desc = "Tab previous" })

-- Formats
map("n", "<leader>fb", "gg=G<cr>", { desc = "[f]ormat [b]uffer vim style" })
map("n", "<leader>fp", "=ap<cr>", { desc = "[f]ormat [p]aragraph" })
map("n", "<leader>fc", ":lua vim.lsp.buf.format()<cr>", { desc = "[f]ormat [c]onfirm plugin" })

-- Show/hide columns
map("n", "<leader>nh", ":set hlsearch!<cr>", { desc = "[n]o [h]ighlite search" })
map("n", "<leader>nn", ":set number!<cr>", { desc = "[n]o [n]umbers" })
map("n", "<leader>nr", ":set relativenumber!<cr>", { desc = "[n] [r]elativenumbers" })
map("n", "<leader>ns", ":lua ToggleSignColumn()<cr>", { noremap = true, silent = true, desc = " [n]o [s]igncolumn" })

-- Sessions
map("n", "<leader>sr", ":source Session.vim<cr>", { desc = "[s]ession [r]estore for cwd" })
map("n", "<leader>ss", ":NvimTreeClose<cr>:mksession!<cr>", { desc = "[s]ession [s]ave for cwd" })

-- Vim config an cheatsheet
map("n", "<leader>vc", ":e ~/gtd/cheatsheets/vim.md<cr>", { desc = "[v]im [c]heatsheet" })
map("n", "<leader>vf", ":e $MYVIMRC<cr>:NvimTreeFindFile!<cr>", { desc = "n[v]im [f]iles" })

-- Application related
map("n", "<leader>m", ":!qownnotes %&<cr>", { desc = "[o]pen buffer [m]arkdown in qownnotes" })
map("n", "<leader>o", ":!xdg-open %&<cr>", { desc = "[o]pen buffer in default application" })

-- Toggle signcolumn.
function ToggleSignColumn()
  if vim.b.signcolumn_on == nil or vim.b.signcolumn_on == 1 then
    vim.wo.signcolumn = "no"
    vim.b.signcolumn_on = 0
  else
    vim.wo.signcolumn = "yes"
    vim.b.signcolumn_on = 1
  end
end
