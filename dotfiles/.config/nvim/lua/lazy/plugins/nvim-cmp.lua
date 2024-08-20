return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path",   -- source for file system paths
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
    local cmp = require("cmp")

    local ls = require("luasnip")

    -- Load snippets from `snippets` directory or any other source
    require('snippets')

    vim.keymap.set({ "i" }, "<C-k>", function() ls.expand() end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<C-l>", function() ls.jump(1) end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<C-j>", function() ls.jump(-1) end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<C-e>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { silent = true })

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          ls.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),             -- show completion suggestions
        ["<C-k>"] = cmp.mapping.select_prev_item(),         -- go suggestion up
        ["<C-j>"] = cmp.mapping.select_next_item(),         -- go suggestion down
        ["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Except [y]es
        ["<C-e>"] = cmp.mapping.abort(),                    -- [E]xit completion window
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- snippets
        { name = "buffer" },  -- text within current buffer
        { name = "path" },    -- file system paths
      }),

    })
  end,
}
