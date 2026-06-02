-- Cheatsheet section: Git (gitsigns hunks)
return {
  title = 'Git',
  items = {
    { key = ']h  [h',     desc = 'Next / prev hunk' },
    { key = '<leader>hs', desc = 'Stage hunk' },
    { key = '<leader>hr', desc = 'Reset hunk' },
    { key = '<leader>hp', desc = 'Preview hunk' },
    { key = '<leader>hb', desc = 'Blame line (full)' },
    { key = '<leader>hd', desc = 'Diff against index' },
    { key = '<leader>tb', desc = 'Toggle inline blame' },
  },
}
