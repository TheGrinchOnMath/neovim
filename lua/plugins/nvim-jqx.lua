-- https://github.com/gennaro-tedesco/nvim-jqx
-- interactive JSON viewing
return {
  'gennaro-tedesco/nvim-jqx',
  event = { 'BufReadPost' },
  ft = { 'json', 'yaml' },
}
