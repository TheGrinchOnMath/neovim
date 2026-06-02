-- Cheatsheet section: LSP / Symbols
-- All buffer-local, set on LspAttach in lua/plugins/nvim-lspconfig.lua.
return {
  title = 'LSP / Symbols',
  items = {
    { key = 'gr',         desc = 'References (Telescope)' },
    { key = 'gI',         desc = 'Go to implementation' },
    { key = 'gD',         desc = 'Go to declaration' },
    { key = '<leader>D',  desc = 'Type definition' },
    { key = '<leader>ds', desc = 'Document symbols' },
    { key = '<leader>ws', desc = 'Workspace symbols' },
  },
}
