return {
  "hrsh7th/nvim-cmp",
  -- enabled = false,
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",   -- source for text in buffer
    "hrsh7th/cmp-path",     -- source for file system paths
    "hrsh7th/cmp-nvim-lsp", -- Do we need to setup somemore (capabilities) in this file?
    {
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
    },
    "saadparwaiz1/cmp_luasnip", -- for autocompletion
  },
  config = function()
    local ls = require("luasnip")
    -- Load snippets from `snippets` directory or any other source
    require('snippets')
    -- keymaps to jump in snippet
    vim.keymap.set({ "i", "s" }, "<C-l>", function() ls.jump(1) end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<C-j>", function() ls.jump(-1) end, { silent = true })

    local cmp = require("cmp")
    cmp.setup({
      -- completion = {
      --   completeopt = "menu,preview",  -- is default help: completeopt
      -- },
      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          ls.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-leader>"] = cmp.mapping.complete(),             -- show completion suggestions
        ["<C-k>"] = cmp.mapping.select_prev_item(),         -- go suggestion up
        ["<C-j>"] = cmp.mapping.select_next_item(),         -- go suggestion down
        ["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Except [y]es
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },                     -- snippets
        { name = "buffer",  keyword_length = 3 }, -- text within current buffer
        { name = "path" },                        -- file system paths
        { name = "vim-dadbod-completion" },
      }),

    })
  end,
}

