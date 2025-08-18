-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--  To check the current status of your plugins, run
--    :Lazy

-- NOTE: this condition is necessary if using the nvim-vscodium plugin
local plugins = vim.g.vscode
    and {
      -- import all plugins --
      require 'plugins.mini',
      require 'plugins.comment',
      require 'plugins.gruvbox',
      require 'plugins.lazydev',
      -- use when working with hex code colors
      -- require 'plugins.nvim-colorizer',
      -- require("plugins.nvim-treesitter"),
      require 'plugins.which-key',
      require 'plugins.todo-comments',
    }
  or {
    -- try getting this one plugin to work FIXME
    require 'plugins.copilot',

    -- import all plugins --
    require 'plugins.alpha',
    require 'plugins.autopairs',
    require 'plugins.blink',
    -- require 'plugins.go',
    require 'plugins.mini',
    require 'plugins.neogit',
    require 'plugins.neo-tree',
    require 'plugins.lualine',
    require 'plugins.debug',
    require 'plugins.chezmoi',
    -- require 'plugins.clangd_extensions',
    require 'plugins.blink',
    require 'plugins.comment',
    require 'plugins.gitsigns',
    require 'plugins.gruvbox',
    require 'plugins.indent_line',
    require 'plugins.lazydev',
    require 'plugins.markdown-preview',
    require 'plugins.multiple-cursors',
    require 'plugins.neominimap',
    -- use when working with hex code colors
    -- require 'plugins.nvim-colorizer',
    require 'plugins.nvim-jqx',
    require 'plugins.nvim-lspconfig',
    require 'plugins.nvim-treesitter',
    require 'plugins.nvim-ufo',
    -- require 'plugins.ft-python.f-string-toggle',
    require 'plugins.telescope',
    require 'plugins.which-key',
    require 'plugins.todo-comments',
  }

require('lazy').setup(plugins, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
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
