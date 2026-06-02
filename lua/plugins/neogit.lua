return { -- https://github.com/NeogitOrg/neogit
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration

    -- Only one of these is needed.
    'nvim-telescope/telescope.nvim', -- optional
    'ibhagwan/fzf-lua', -- optional
    'echasnovski/mini.pick', -- optional
  },
  config = true,
  -- Keys lazy-load neogit (and its diffview dependency) on first use.
  -- Documented in the cheatsheet via lua/config/cheatsheet/sections/55-neogit.lua
  -- and 57-diffview.lua.
  keys = {
    { '<leader>gg', '<cmd>Neogit<CR>', desc = 'Neogit status' },
    { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = 'Diffview open (vs index)' },
    { '<leader>gD', '<cmd>DiffviewFileHistory %<CR>', desc = 'Diffview file history' },
    { '<leader>gq', '<cmd>DiffviewClose<CR>', desc = 'Diffview close' },
  },
}
