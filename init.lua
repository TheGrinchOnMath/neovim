--[[

=====================================================================
====================== WELCOME TO THE FUN ZONE ======================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||     GRONK.NVIM     ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Lazy               ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- vim.opt.relativenumber = true

-- TODO configure tmux

-- [[ Setting options ]]
require 'config.opt'

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
require 'config.keymap'

require 'config.lsp'

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Lazy.nvim plugin manager --
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

-- if vim.g.vscode then
--   require('lazy').setup({
--     require 'plugins.autopairs',
--     require 'plugins.conform',
--     require 'plugins.mini',
--
--     require 'plugins.todo-comments',
--     require 'plugins.gruvbox',
--     require 'plugins.which-key',
--     require 'plugins.gitsigns',
--     require 'plugins.comment',
--   }, {
--     ui = {
--       -- If you are using a Nerd Font: set icons to an empty table which will use the
--       -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
--       icons = vim.g.have_nerd_font and {} or {
--         cmd = '⌘',
--         config = '🛠',
--         event = '📅',
--         ft = '📂',
--         init = '⚙',
--         keys = '🗝',
--         plugin = '🔌',
--         runtime = '💻',
--         require = '🌙',
--         source = '📄',
--         start = '🚀',
--         task = '📌',
--         lazy = '💤 ',
--       },
--     },
--   })
-- else
--   -- no vscode support for now
--   -- [[ Lazy Plugin Manager ]]
--   require('lazy').setup({
--     -- import all plugins --
--     require 'plugins.alpha',
--     require 'plugins.autopairs',
--     -- require("plugins.cmp"),
--     require 'plugins.blink',
--     require 'plugins.conform',
--     -- require 'plugins.go',
--     require 'plugins.mini',
--     require 'plugins.neogit',
--     require 'plugins.neo-tree',
--     require 'plugins.lualine',
--     require 'plugins.debug',
--     require 'plugins.chezmoi',
--     -- require 'plugins.clangd_extensions',
--     require 'plugins.comment',
--     require 'plugins.gitsigns',
--     require 'plugins.gruvbox',
--     require 'plugins.indent_line',
--     require 'plugins.lazydev',
--     require 'plugins.markdown-preview',
--     require 'plugins.neominimap',
--     -- use when working with hex code colors
--     -- require 'plugins.nvim-colorizer',
--     require 'plugins.nvim-jqx',
--     require 'plugins.nvim-lspconfig',
--     require 'plugins.nvim-treesitter',
--     require 'plugins.nvim-ufo',
--     require 'plugins.ft-python.f-string-toggle',
--     require 'plugins.telescope',
--     require 'plugins.which-key',
--     require 'plugins.todo-comments',
--   }, {
--     ui = {
--       -- If you are using a Nerd Font: set icons to an empty table which will use the
--       -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
--       icons = vim.g.have_nerd_font and {} or {
--         cmd = '⌘',
--         config = '🛠',
--         event = '📅',
--         ft = '📂',
--         init = '⚙',
--         keys = '🗝',
--         plugin = '🔌',
--         runtime = '💻',
--         require = '🌙',
--         source = '📄',
--         start = '🚀',
--         task = '📌',
--         lazy = '💤 ',
--       },
--     },
--   })
-- end

-- no vscode support for now
-- [[ Lazy Plugin Manager ]]
require('lazy').setup({
  -- import all plugins --
  require 'plugins.alpha',
  require 'plugins.autopairs',
  -- require("plugins.cmp"),
  require 'plugins.blink',
  require 'plugins.conform',
  -- require 'plugins.go',
  require 'plugins.mini',
  require 'plugins.neogit',
  require 'plugins.neo-tree',
  require 'plugins.lualine',
  require 'plugins.debug',
  require 'plugins.chezmoi',
  -- require 'plugins.clangd_extensions',
  require 'plugins.comment',
  require 'plugins.gitsigns',
  require 'plugins.gruvbox',
  require 'plugins.indent_line',
  require 'plugins.lazydev',
  require 'plugins.markdown-preview',
  require 'plugins.neominimap',
  -- use when working with hex code colors
  -- require 'plugins.nvim-colorizer',
  require 'plugins.nvim-jqx',
  require 'plugins.nvim-lspconfig',
  require 'plugins.nvim-treesitter',
  require 'plugins.nvim-ufo',
  require 'plugins.ft-python.f-string-toggle',
  require 'plugins.telescope',
  require 'plugins.which-key',
  require 'plugins.todo-comments',

  -- imports all plugins
  -- { import = 'plugins' },
}, {
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

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
