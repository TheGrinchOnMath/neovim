-- https://github.com/akinsho/bufferline.nvim
return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VimEnter',
  keys = {
    { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
    { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
    { '<leader>bp', '<cmd>BufferLineTogglePin<cr>', desc = 'Toggle buffer [P]in' },
    { '<leader>bx', '<cmd>bdelete<cr>', desc = 'Close buffer' },
    { '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', desc = 'Close [O]ther buffers' },
  },
  opts = {
    options = {
      mode = 'buffers',
      numbers = 'none',
      close_command = 'bdelete! %d',
      diagnostics = 'nvim_lsp',
      diagnostics_indicator = function(count, level)
        local icon = level:match 'error' and '󰅚 ' or '󰀪 '
        return icon .. count
      end,
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'File Explorer',
          highlight = 'Directory',
          separator = true,
        },
      },
      show_buffer_close_icons = true,
      show_close_icon = false,
      separator_style = 'slant',
      always_show_bufferline = true,
    },
    -- Blend slant separator teeth into the fill background (Normal bg).
    -- `tab_separator*` only applies in tab mode; in buffer mode the groups
    -- are `separator`, `separator_selected`, and `separator_visible`.
    highlights = {
      fill = {
        bg = { attribute = 'bg', highlight = 'Normal' },
      },
      separator = {
        fg = { attribute = 'bg', highlight = 'Normal' },
      },
      separator_selected = {
        fg = { attribute = 'bg', highlight = 'Normal' },
      },
      separator_visible = {
        fg = { attribute = 'bg', highlight = 'Normal' },
      },
    },
  },
}
