-- Cheatsheet section: Navigation
-- See ../init.lua for the loader and doc/cheatsheet.md for how sections work.
return {
  title = 'Navigation',
  items = {
    { key = 'Ctrl+h/j/k/l',  desc = 'Switch window' },
    { key = ']b  [b',        desc = 'Next / prev buffer' },
    { key = '<Space>t',      desc = 'Toggle file tree' },
    { key = '<C-d>  <C-u>',  desc = 'Scroll half-page down/up' },
    { key = 'gg  G',         desc = 'Top / bottom of file' },
    { key = '<C-o>  <C-i>',  desc = 'Jump back / forward' },
    { key = 'gd  K',         desc = 'Definition / hover docs' },
    { key = ']d  [d',        desc = 'Next / prev diagnostic' },
    { key = '*  #',          desc = 'Search word fwd / bwd' },
    { key = 'za  zR  zM',    desc = 'Toggle/open/close folds' },
    { key = '<leader>zp',    desc = 'Peek folded lines (ufo)' },
  },
}
