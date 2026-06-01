-- https://github.com/goolord/alpha-nvim
-- Keeps theta's two-column layout (MRU left, buttons right).
-- Buttons are replaced with project-specific quick links.
return {
  'goolord/alpha-nvim',
  dependencies = { 'echasnovski/mini.icons' },
  config = function()
    local alpha     = require 'alpha'
    local theta     = require 'alpha.themes.theta'
    local dashboard = require 'alpha.themes.dashboard'

    -- ── Custom buttons ──────────────────────────────────────────────────────
    -- dashboard.button(shortcut, label_with_icon, action)
    -- shortcut appears as [key] on the right side of each row
    theta.buttons.val = {
      { type = 'text', val = 'Quick Links', opts = { hl = 'SpecialComment', position = 'center' } },
      { type = 'padding', val = 1 },
      dashboard.button('f', '  Find File',     '<cmd>Telescope find_files<CR>'),
      dashboard.button('r', '  Recent Files',  '<cmd>Telescope oldfiles<CR>'),
      dashboard.button('g', '  Live Grep',     '<cmd>Telescope live_grep<CR>'),
      dashboard.button('n', '  New File',      '<cmd>ene <BAR> startinsert<CR>'),
      dashboard.button('?', '  Cheatsheet',    '<cmd>lua require("config.cheatsheet").toggle()<CR>'),
      dashboard.button('/', '  Search Keys',   '<cmd>lua require("config.cheatsheet").picker()<CR>'),
      dashboard.button('l', '󰒲  Lazy',          '<cmd>Lazy<CR>'),
      dashboard.button('q', '  Quit',          '<cmd>qa<CR>'),
    }

    -- ── Footer: nvim version ────────────────────────────────────────────────
    theta.config.layout[#theta.config.layout] = {
      type = 'text',
      val  = 'GRONK.NVIM  ·  v' .. tostring(vim.version()),
      opts = { hl = 'Comment', position = 'center' },
    }

    alpha.setup(theta.config)

    -- Close alpha automatically when a real buffer is opened
    vim.api.nvim_create_autocmd('User', {
      pattern  = 'AlphaReady',
      callback = function()
        vim.keymap.set('n', 'q', '<cmd>qa<CR>', { buffer = true, silent = true })
      end,
    })
  end,
}
