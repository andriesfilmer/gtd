return {
  {
    'akinsho/bufferline.nvim',
    enabled = false,
    version = 'v4.*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup {
        options = {
          separator_style = 'thin',
          truncate_names = false,
          -- tab_size = 8,
          mode = 'buffers',
          numbers = "none",
          diagnostics = 'nvim_lsp',
          show_buffer_icons = false,
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = true,
          -- enforce_regular_tabs = true,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
            }
          },
          groups = {
            options = {
              toggle_hidden_on_enter = true,
            },
            items = {
              require("bufferline.groups").builtin.ungrouped,
              {
                name = "Assets",
                highlight = { sp = "DarkTurquoise" },
                matcher = function(buf)
                  return vim.startswith(buf.path, vim.fn.getcwd() .. "/app/assets/")
                end,
              },
              {
                name = "Ruby",
                highlight = { sp = "DarkMagenta" },
                icon = '',
                matcher = function(buf)
                  return buf.name:match('%.rb') or buf.name:match('%.rake')
                end,
              },
              {
                name = "Erb",
                highlight = { sp = "CornFlowerBlue" },
                matcher = function(buf)
                  return buf.name:match('%.erb')
                end,
              },
              {
                name = "MD",
                highlight = { sp = "DarkGray" },
                matcher = function(buf)
                  return buf.name:match('%.md')
                end,
              },
            },
          },
        },
        highlights = {
          buffer_selected = {
            fg = 'White',
            bg = 'Green',
          },
          modified = {
            fg = 'Red',
            bg = 'Black',
          },
          modified_visible = {
            fg = 'Red',
            bg = 'LightGrey',
          },
          modified_selected = {
            fg = 'Red',
            bg = 'Green',
          },
          separator = {
            fg = "LightGrey",
            bg = "Black",
          },
        },
      }
      local map = vim.api.nvim_set_keymap
      map('n', '<leader>bt', ':BufferLineGroupToggle', { desc = 'Toggle group'})
      map('n', '<leader>bg', ':BufferLineGoToBuffer', { desc = 'Go to Bufferline'})
      map("n", "<leader>bp", ":BufferLinePick<cr>", { desc = "Pick BufferLine" })
    end,
  }
}

