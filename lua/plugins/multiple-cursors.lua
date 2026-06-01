-- https://github.com/brenton-leighton/multiple-cursors.nvim
-- Note: <C-j>/<C-k> are reserved for window navigation; use <M-j>/<M-k> here
return {
  'brenton-leighton/multiple-cursors.nvim',
  version = '*',
  opts = {},
  keys = {
    { '<M-j>', '<Cmd>MultipleCursorsAddDown<CR>', mode = { 'n', 'x' }, desc = 'Add cursor and move down' },
    { '<M-k>', '<Cmd>MultipleCursorsAddUp<CR>', mode = { 'n', 'x' }, desc = 'Add cursor and move up' },

    -- Insert/visual only to avoid clashing with resize keymaps in normal mode
    { '<C-Down>', '<Cmd>MultipleCursorsAddDown<CR>', mode = { 'i', 'x' }, desc = 'Add cursor and move down' },
    { '<C-Up>', '<Cmd>MultipleCursorsAddUp<CR>', mode = { 'i', 'x' }, desc = 'Add cursor and move up' },

    { '<C-LeftMouse>', '<Cmd>MultipleCursorsMouseAddDelete<CR>', mode = { 'n', 'i' }, desc = 'Add or remove cursor' },

    { '<Leader>m', '<Cmd>MultipleCursorsAddVisualArea<CR>', mode = { 'x' }, desc = 'Add cursors to visual area lines' },
    { '<Leader>a', '<Cmd>MultipleCursorsAddMatches<CR>', mode = { 'n', 'x' }, desc = 'Add cursors to cword' },
    { '<Leader>A', '<Cmd>MultipleCursorsAddMatchesV<CR>', mode = { 'n', 'x' }, desc = 'Add cursors to cword in previous area' },
    { '<Leader>d', '<Cmd>MultipleCursorsAddJumpNextMatch<CR>', mode = { 'n', 'x' }, desc = 'Add cursor and jump to next cword' },
    { '<Leader>D', '<Cmd>MultipleCursorsJumpNextMatch<CR>', mode = { 'n', 'x' }, desc = 'Jump to next cword' },
    { '<Leader>l', '<Cmd>MultipleCursorsLock<CR>', mode = { 'n', 'x' }, desc = 'Lock virtual cursors' },
  },
}
