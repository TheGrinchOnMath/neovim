-- Cheatsheet section: Diffview (side-by-side diffs)
-- Open/close bindings in lua/plugins/neogit.lua; Tab is an in-buffer default.
return {
  title = 'Diffview',
  items = {
    { key = '<leader>gd',     desc = 'Open diff (vs index)' },
    { key = '<leader>gD',     desc = 'File history (current)' },
    { key = '<leader>gq',     desc = 'Close diffview' },
    { key = '<Tab>  <S-Tab>', desc = 'Next / prev changed file' },
  },
}
