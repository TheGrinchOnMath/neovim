-- https://github.com/folke/trouble.nvim
-- Better diagnostics list, quickfix and location list
return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Workspace Diagnostics (Trouble)' },
    { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
    { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
    { '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Defs / Refs (Trouble)' },
    { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
    { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
  },
  opts = {},
}
