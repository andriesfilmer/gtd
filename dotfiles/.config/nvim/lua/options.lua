vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


vim.opt.mouse = ''                      -- Don't use mouse
vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register
vim.opt.ignorecase = true               -- Search: ignore case
vim.opt.smartcase = true                -- Search: ignore case, unless uppercase chars given
vim.opt.autowrite = true                -- Write the contents of the file, if it has been modified
vim.opt.tabstop = 4                     -- tab with 4 spaces width
vim.opt.shiftwidth = 2
vim.opt.shiftround = true               -- Indentation: When at 3 spaces, >> takes to 4, not 5
vim.opt.expandtab = true                -- Use the appropriate number of spaces
vim.opt.cursorline = true               -- Highlight current line
vim.opt.relativenumber = true           -- Set relative line numbers
vim.opt.number = true                   -- Set line numbers
vim.opt.wrap = false                    -- Wrapping on, default commented out
vim.opt.signcolumn = "yes"              -- show sign column so that text doesn't shift
vim.opt.splitbelow = true               -- force all horizontal splits to go below current window
vim.opt.splitright = true               -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                -- turn off swapfile

-- Optional
-- vim.opt.colorcolumn = { 80, 120 }      -- Show vertical bars to indicate 80/120 chars

-- Persistent Cursor - jump to last position when reopening file
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Show trailing spaces
vim.cmd [[
  highlight ExtraWhitespace ctermbg=red guibg=red
  match ExtraWhitespace /\s\+$/
]]

-- Remove trailing spaces on save buffer
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = ":%s/\\s\\+$//e",
})


-- Other options to investigate
--
--  backup = false,                           -- creates a backup file
--  cmdheight = 2,                            -- more space in the neovim command line for displaying messages
--  completeopt = { "menuone", "noselect" },  -- mostly just for cmp
--  conceallevel = 0,                         -- so that `` is visible in markdown files
--  fileencoding = "utf-8",                   -- the encoding written to a file
--  hidden = true,                            -- required to keep multiple buffers and open multiple buffers
--  pumheight = 10,                           -- pop up menu height
--  showmode = false,                         -- we don't need to see things like -- INSERT -- anymore
--  showtabline = 2,                          -- always show tabs
--  smartindent = true,                       -- make indenting smarter again
--  guifont = "monospace:h17",                -- the font used in graphical neovim applications
