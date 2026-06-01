-- https://github.com/folke/noice.nvim
-- Replaces the default command-line UI, messages and notifications
return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    { 'rcarriga/nvim-notify', opts = { timeout = 3000, render = 'compact' } },
  },
  opts = {
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
      },
      -- blink.cmp handles signature help
      signature = { enabled = false },
    },
    presets = {
      bottom_search = true,
      command_palette = false,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
  },
  keys = {
    { '<leader>nl', '<cmd>Noice last<cr>', desc = '[N]oice [L]ast message' },
    { '<leader>nh', '<cmd>Noice history<cr>', desc = '[N]oice [H]istory' },
    { '<leader>nd', '<cmd>Noice dismiss<cr>', desc = '[N]oice [D]ismiss' },
  },
}
