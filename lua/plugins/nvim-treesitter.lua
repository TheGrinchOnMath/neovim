return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    local parsers = {
      'bash',
      'diff',
      'gitcommit',
      'gitignore',
      'go',
      'gomod',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'powershell',
      'python',
      'query',
      'rust',
      'toml',
      'vim',
      'vimdoc',
      'yaml',
    }

    -- nvim-treesitter moved away from the 'configs' sub-module in its rewrite.
    -- Try the legacy API first; fall back to the new one.
    local ok, configs = pcall(require, 'nvim-treesitter.configs')
    if ok then
      configs.setup {
        ensure_installed = parsers,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
      }
    else
      -- Post-rewrite API: highlighting is handled by neovim's built-in
      -- treesitter integration; this just manages parser installation.
      require('nvim-treesitter').setup {
        ensure_installed = parsers,
        auto_install = true,
      }
    end
  end,
}
