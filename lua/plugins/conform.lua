return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = function(_)
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_format', 'ruff_organize_imports' },
      -- rustfmt is invoked via rust_analyzer's built-in formatting
      rust = { lsp_format = 'prefer' },
      go = { 'goimports', 'gofmt' },
      sh = { 'shfmt' },
      bash = { 'shfmt' },
      yaml = { 'prettier' },
      toml = { 'taplo' },
      markdown = { 'prettier' },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettier' },
    },
  },
}
