-- https://github.com/goolord/alpha-nvim
-- Uses theta's layout (header → MRU → buttons), with custom buttons.
return {
  'goolord/alpha-nvim',
  dependencies = { 'echasnovski/mini.icons' },
  config = function()
    local alpha     = require 'alpha'
    local theta     = require 'alpha.themes.theta'
    local dashboard = require 'alpha.themes.dashboard'

    -- ── Replace theta's button list ─────────────────────────────────────────
    -- theta.buttons is the same table reference used in theta.config.layout,
    -- so mutating .val here is reflected in the layout automatically.
    theta.buttons.val = {
      { type = 'text', val = 'Quick Links', opts = { hl = 'SpecialComment', position = 'center' } },
      { type = 'padding', val = 1 },
      dashboard.button('f', '  Find File',    '<cmd>Telescope find_files<CR>'),
      dashboard.button('r', '  Recent Files', '<cmd>Telescope oldfiles<CR>'),
      dashboard.button('g', '  Live Grep',    '<cmd>Telescope live_grep<CR>'),
      dashboard.button('n', '  New File',     '<cmd>ene <BAR> startinsert<CR>'),
      dashboard.button('?', '  Cheatsheet',   '<cmd>lua require("config.cheatsheet").toggle()<CR>'),
      dashboard.button('/', '  Search Keys',  '<cmd>lua require("config.cheatsheet").picker()<CR>'),
      dashboard.button('l', '󰒲  Lazy',         '<cmd>Lazy<CR>'),
      dashboard.button('q', '  Quit',         '<cmd>qa<CR>'),
    }

    -- ── Append a version footer after the buttons (don't replace them) ──────
    table.insert(theta.config.layout, { type = 'padding', val = 1 })
    table.insert(theta.config.layout, {
      type = 'text',
      val  = 'GRONK.NVIM  ·  nvim v' .. tostring(vim.version()),
      opts = { hl = 'Comment', position = 'center' },
    })

    alpha.setup(theta.config)

    -- q closes the dashboard
    vim.api.nvim_create_autocmd('User', {
      pattern  = 'AlphaReady',
      callback = function()
        vim.keymap.set('n', 'q', '<cmd>qa<CR>', { buffer = true, silent = true })
      end,
    })
  end,
}
