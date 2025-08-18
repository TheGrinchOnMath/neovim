return { -- gruvbox theme, vere nais
  'ellisonleao/gruvbox.nvim',
  priority = 1000,
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('gruvbox').setup {
      contrast = 'hard',
      styles = {
        comments = { italic = false }, --- Disable italics in comments
      },
    }
    -- vim.cmd.colorscheme 'gruvbox-dark'
    vim.o.background = 'dark'
    vim.cmd 'colorscheme gruvbox'
  end,
}
