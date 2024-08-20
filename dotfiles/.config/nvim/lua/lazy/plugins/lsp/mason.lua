return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
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

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "html",
        "cssls",
        "tsserver",
        "ruby_lsp", -- Also attached to html.erb which give errors.
        "rubocop",
        -- "solargraph",   -- Also too many errors for me
        -- "sorbet",       -- https://sorbet.org/ - gem install sorbet
        -- "standardrb",   -- https://github.com/standardrb/standard - gem "standard"
        -- "steep",        -- https://github.com/soutaro/steep - You need Steepfile to make it work
        "lua_ls",
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