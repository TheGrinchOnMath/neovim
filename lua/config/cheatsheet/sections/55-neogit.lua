-- Cheatsheet section: Neogit (full git UI)
-- <leader>gg opens it (see lua/plugins/neogit.lua). Remaining keys are
-- Neogit's own in-buffer bindings, active only inside the Neogit window.
return {
  title = 'Neogit',
  items = {
    { key = '<leader>gg', desc = 'Open Neogit status' },
    { key = 's  u',       desc = 'Stage / unstage' },
    { key = 'cc',         desc = 'Commit' },
    { key = 'Fp  Fl',     desc = 'Push / pull' },
    { key = 'b',          desc = 'Branch management' },
    { key = 'q',          desc = 'Close Neogit' },
  },
}
