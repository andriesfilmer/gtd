
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
vim.opt.wrap = false                    -- Wrapping on, default on
vim.opt.signcolumn = "yes"              -- show sign column so that text doesn't shift
vim.opt.splitbelow = true               -- force all horizontal splits to go below current window
vim.opt.splitright = true               -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                -- turn off swapfile
vim.opt.pumheight = 10			       	-- number of items in popup menu
vim.opt.scrolloff = 8			        -- scroll page when cursor is 8 lines from top/bottom
vim.opt.sidescrolloff = 8		      	-- scroll page when cursor is 8 spaces from left/right


-------------------- Begin statusline ----------------------

-- Function to show how many buffers are open in the status line.
function BufferCount()
  local buffers = vim.api.nvim_list_bufs()
  local count = 0
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      count = count + 1
    end
  end
  return count
end

vim.cmd "highlight StatusType guibg=#b16286 guifg=#1d2021"
vim.cmd "highlight StatusFile guibg=#fabd2f guifg=#1d2021"
vim.cmd "highlight StatusModified guibg=#1d2021 guifg=#d3869b"
vim.cmd "highlight StatusBuffer guibg=#98971a guifg=#1d2021"
vim.cmd "highlight StatusLocation guibg=#458588 guifg=#1d2021"
vim.cmd "highlight StatusPercent guibg=#1d2021 guifg=#ebdbb2"
vim.cmd "highlight StatusNorm guibg=none guifg=white"
vim.o.statusline = " "
				.. "  %#StatusType# "
				.. " %Y "
				.. "   "
				.. " %#StatusFile# "
				.. " %F"
				.. " %#StatusModified# "
				.. " %m"
				.. " %#StatusNorm# "
				.. " %="
				.. " %#StatusBuffer# "
				.. " 󰽘 "
				.. " %{v:lua.BufferCount()}/%n"
				.. " %#StatusLocation# "
				.. "  "
				.. " %l,%c "
				.. " %#StatusPercent# "
				.. " %p%%  "

-------------------- End statusline ------------------------

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


