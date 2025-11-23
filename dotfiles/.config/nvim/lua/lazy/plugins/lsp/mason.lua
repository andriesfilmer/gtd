return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    -- Setup capabilities before mason-lspconfig
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        --"html",
        "cssls",
        "ruby_lsp",
        "rubocop",
        -- "solargraph",   -- Too many errors for me
        -- "sorbet",       -- https://sorbet.org/ - gem install sorbet
        -- "standardrb",   -- https://github.com/standardrb/standard - gem "standard"
        -- "steep",        -- https://github.com/soutaro/steep - You need Steepfile to make it work
        "lua_ls",
      },
      -- Automatic server setup with handlers
      handlers = {
        -- default handler for installed servers
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
        })
      end,
      ["ruby_lsp"] = function()
        lspconfig["ruby_lsp"].setup({
          capabilities = capabilities,
          filetypes = { "ruby", "rake" },
        })
      end,
      ["emmet_ls"] = function()
        lspconfig["emmet_ls"].setup({
          capabilities = capabilities,
          filetypes = { "html", "javascriptreact", "css", "sass", "scss", "less" },
        })
      end,
      ["lua_ls"] = function()
        lspconfig["lua_ls"].setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
                disable = { "missing-parameters", "missing-fields" }
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        })
      end,
    },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua",   -- lua formatter
      },
    })
  end,
}
