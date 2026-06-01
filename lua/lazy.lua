local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Plugins loaded in both neovim and vscode-neovim
local vscode_plugins = {
  require 'plugins.autopairs',
  require 'plugins.comment',
  require 'plugins.gruvbox',
  require 'plugins.lazydev',
  require 'plugins.mini',
  require 'plugins.todo-comments',
  require 'plugins.which-key',
}

-- Full plugin set for standalone neovim
local full_plugins = {
  require 'plugins.alpha',
  require 'plugins.autopairs',
  require 'plugins.blink',
  require 'plugins.bufferline',
  require 'plugins.chezmoi',
  require 'plugins.comment',
  require 'plugins.conform',
  require 'plugins.debug',
  require 'plugins.ft-python.f-string-toggle',
  require 'plugins.gitsigns',
  require 'plugins.gruvbox',
  require 'plugins.indent_line',
  require 'plugins.lazydev',
  require 'plugins.lualine',
  require 'plugins.markdown-preview',
  require 'plugins.mini',
  require 'plugins.multiple-cursors',
  require 'plugins.neo-tree',
  require 'plugins.neogit',
  require 'plugins.neominimap',
  require 'plugins.noice',
  require 'plugins.nvim-jqx',
  require 'plugins.nvim-lspconfig',
  require 'plugins.nvim-treesitter',
  require 'plugins.nvim-ufo',
  require 'plugins.telescope',
  require 'plugins.todo-comments',
  require 'plugins.trouble',
  require 'plugins.which-key',
}

require('lazy').setup(vim.g.vscode and vscode_plugins or full_plugins, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
