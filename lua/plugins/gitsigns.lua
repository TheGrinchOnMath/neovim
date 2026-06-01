return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gs = require 'gitsigns'
      local function map(mode, l, r, opts)
        opts = vim.tbl_extend('force', { buffer = bufnr }, opts or {})
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']h', gs.next_hunk, { desc = 'Next Git [H]unk' })
      map('n', '[h', gs.prev_hunk, { desc = 'Prev Git [H]unk' })

      -- Hunk actions
      map('n', '<leader>hs', gs.stage_hunk, { desc = 'Git [S]tage Hunk' })
      map('n', '<leader>hr', gs.reset_hunk, { desc = 'Git [R]eset Hunk' })
      map('v', '<leader>hs', function()
        gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Git [S]tage Hunk' })
      map('v', '<leader>hr', function()
        gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Git [R]eset Hunk' })
      map('n', '<leader>hS', gs.stage_buffer, { desc = 'Git [S]tage Buffer' })
      map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Git [U]ndo Stage Hunk' })
      map('n', '<leader>hR', gs.reset_buffer, { desc = 'Git [R]eset Buffer' })
      map('n', '<leader>hp', gs.preview_hunk, { desc = 'Git [P]review Hunk' })
      map('n', '<leader>hb', function()
        gs.blame_line { full = true }
      end, { desc = 'Git [B]lame Line' })
      map('n', '<leader>hd', gs.diffthis, { desc = 'Git [D]iff Against Index' })
      map('n', '<leader>hD', function()
        gs.diffthis '~'
      end, { desc = 'Git [D]iff Against Last Commit' })

      -- Toggles
      map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = '[T]oggle Git [B]lame' })
      map('n', '<leader>td', gs.toggle_deleted, { desc = '[T]oggle Show [D]eleted' })
    end,
  },
}
