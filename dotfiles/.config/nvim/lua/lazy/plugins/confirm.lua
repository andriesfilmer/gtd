return {
  'stevearc/conform.nvim',
  opts = {
    format_on_save = {
      timeout_ms = 5000,
      lsp_fallback = true,
    },
    formatters_by_ft = {
      ruby = { 'rubocop' },
    },
  },
}
