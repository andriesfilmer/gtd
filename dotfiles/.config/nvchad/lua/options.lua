require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-- Use relative & absolute line numbers in 'n' & 'i' modes respectively
--vim.cmd[[ au InsertEnter * set norelativenumber ]]
--vim.cmd[[ au InsertLeave * set relativenumber ]]

-- More contrast on Insert mode.
vim.cmd[[ au InsertEnter * highlight St_InsertMode guifg=white guibg=red]]

-- No mouse options
vim.opt.mouse = ''

-- No undo file after closing buffer
vim.o.undofile = false

-- When editing a file, always jump to the last known cursor position.
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    vim.cmd([[normal! g`"]])
  end,
})
