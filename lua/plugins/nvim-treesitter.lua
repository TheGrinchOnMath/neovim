-- https://github.com/nvim-treesitter/nvim-treesitter
-- Requires nvim 0.12+ and tree-sitter-cli in PATH.
-- The plugin manages parser/query installation only;
-- highlighting and indent are handled by nvim's built-in treesitter engine.
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main', -- the new API (require('nvim-treesitter').install) lives on main, not master
  lazy = false, -- plugin explicitly does not support lazy-loading
  build = ':TSUpdate',
  config = function()
    -- New API: setup() only accepts install_dir; default is fine.
    -- Parser installation is via .install(), which is async.
    require('nvim-treesitter').install {
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
  end,
}
