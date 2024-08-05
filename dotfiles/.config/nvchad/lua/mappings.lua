
-- NvChad uses vim.keymap.set by default, check :h vim.keymap.set for detailed docs.
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/mappings.lua

require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- Overwrite default nvchad settings (h,l,j,k)
map("n", "<C-Left>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-Right>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-Down>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-Up>", "<C-w>k", { desc = "switch window up" })


-- Ctrl Save like normal editors
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("n", ";", ":", { desc = "CMD enter command mode" })

map("n", "<Leader><CR>", "<Cmd>noh<CR>", { desc = "Disable Highlights" })
map("n", "<Leader>l", "<Cmd>buffers<CR>", { desc = "List buffers" })

-- Resize with arrows
map("n", "<A-Up>", ":resize -2<CR>", { desc = "Resize window up" })
map("n", "<A-Down>", ":resize +2<CR>",{  desc = "Resize window down" })
map("n", "<A-Left>", ":vertical resize -2<CR>", { desc = "Resize window left" })
map("n", "<A-Right>", ":vertical resize +2<CR>", { desc = "Resize window right" })

-- Stay in indent mode
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- UndotreeToggle
map('n', '<leader><F5>', vim.cmd.UndotreeToggle, { desc = "Open Undotree"})
map("n", "<leader>b", ":NvimTreeFocus<CR>:NvimTreeCollapse<CR>", { desc = "OpenCollapse tree" })

