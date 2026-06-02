return { -- highlight todo, notes and stuff in comments
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = { signs = false },
  -- These are NOT plugin defaults — wired explicitly so which-key shows them.
  -- Documented in lua/config/cheatsheet/sections/75-todo.lua.
  config = function(_, opts)
    local todo = require 'todo-comments'
    todo.setup(opts)
    vim.keymap.set('n', ']t', function()
      todo.jump_next()
    end, { desc = 'Next TODO comment' })
    vim.keymap.set('n', '[t', function()
      todo.jump_prev()
    end, { desc = 'Prev TODO comment' })
    vim.keymap.set('n', '<leader>st', '<cmd>TodoTelescope<CR>', { desc = '[S]earch [T]ODOs' })
  end,
}
