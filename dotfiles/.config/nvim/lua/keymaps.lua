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
map("n", "<space><Up>", ":%bd|e#|bd#<cr>", { desc = "Close bufs/tabs except current" })
map("n", "<space><Left>", ":tabnext<cr>", { desc = "Tab next" })
map("n", "<space><Right>", ":tabprevious<cr>", { desc = "Tab previous" })

-- Formats
map("n", "<space>fb", "gg=G<cr>", { desc = "[f]ormat [b]uffer vim style" })
map("n", "<space>fp", "=ap<cr>", { desc = "[f]ormat [p]aragraph" })
map("n", "<space>fc", ":lua vim.lsp.buf.format()<cr>", { desc = "[f]ormat [c]onfirm plugin" })

-- Show/hide columns
map("n", "<space>nh", ":set hlsearch!<cr>", { desc = "[n]o [h]ighlite search" })
map("n", "<space>nn", ":set number!<cr>", { desc = "[n]o [n]umbers" })
map("n", "<space>nr", ":set relativenumber!<cr>", { desc = "[n] [r]elativenumbers" })
map("n", "<space>ns", ":lua ToggleSignColumn()<cr>", { noremap = true, silent = true, desc = " [n]o [s]igncolumn" })

-- Sessions
map("n", "<space>sr", ":source Session.vim<cr>", { desc = "[s]ession [r]estore for cwd" })
map("n", "<space>ss", ":NvimTreeClose<cr>:mksession!<cr>", { desc = "[s]ession [s]ave for cwd" })

-- Vim config an cheatsheet
map("n", "<space>vc", ":e ~/gtd/cheatsheets/vim.md<cr>", { desc = "[v]im [c]heatsheet" })
map("n", "<space>vf", ":e $MYVIMRC<cr>:NvimTreeFindFile!<cr>", { desc = "n[v]im [f]iles" })

-- Application related
map("n", "<space>o", ":!xdg-open %&<cr>", { desc = "[o]pen buffer in default application" })

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
