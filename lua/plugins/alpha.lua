-- https://github.com/goolord/alpha-nvim
return {
  'goolord/alpha-nvim',
  dependencies = { 'echasnovski/mini.icons' },
  config = function()
    require('alpha').setup(require('alpha.themes.theta').config)
  end,
}
