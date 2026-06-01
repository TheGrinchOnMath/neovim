-- Floating keybind cheatsheet + Telescope picker
--   M.toggle()  → floating window   (bound to <F1>)
--   M.picker()  → telescope search  (bound to <leader>?)

local M = {}

-- Layout constants (all content is ASCII → byte width == display width)
local SEC_W = 44       -- each section column, in display cols
local GAP   = '  |  ' -- column divider, pure ASCII → #GAP == display width == 5
local KEY_W = 19       -- key field width within a section

-- ── Section data ─────────────────────────────────────────────────────────────
-- Exposed as M.sections so alpha and the telescope picker can consume it.
-- Keep in sync with actual plugin keymaps.
M.sections = {
  { title = 'Navigation', items = {
    { key = 'Ctrl+h/j/k/l',     desc = 'Switch window' },
    { key = ']b  [b',           desc = 'Next / prev buffer' },
    { key = '<Space>t',         desc = 'Toggle file tree' },
    { key = 'gg  G',            desc = 'Top / bottom of file' },
    { key = '<C-o>  <C-i>',    desc = 'Jump back / forward' },
  }},
  { title = 'LSP', items = {
    { key = 'gd',               desc = 'Go to definition' },
    { key = 'gr',               desc = 'References' },
    { key = 'gI',               desc = 'Go to implementation' },
    { key = 'gD',               desc = 'Go to declaration' },
    { key = 'K',                desc = 'Hover documentation' },
    { key = '<leader>rn',       desc = 'Rename symbol' },
    { key = '<leader>ca',       desc = 'Code action' },
    { key = '<leader>D',        desc = 'Type definition' },
    { key = '<leader>ds',       desc = 'Document symbols' },
    { key = '<leader>ws',       desc = 'Workspace symbols' },
    { key = '<leader>th',       desc = 'Toggle inlay hints' },
  }},
  { title = 'Search (Telescope)', items = {
    { key = '<leader>sf',       desc = 'Find files' },
    { key = '<leader>sg',       desc = 'Live grep' },
    { key = '<leader>sw',       desc = 'Grep word under cursor' },
    { key = '<leader>/',        desc = 'Fuzzy search in buffer' },
    { key = '<leader><Space>',  desc = 'Open buffers' },
    { key = '<leader>sh',       desc = 'Help tags' },
    { key = '<leader>sd',       desc = 'Search diagnostics' },
    { key = '<leader>sr',       desc = 'Resume last search' },
  }},
  { title = 'Git', items = {
    { key = ']h  [h',          desc = 'Next / prev hunk' },
    { key = '<leader>hs',       desc = 'Stage hunk' },
    { key = '<leader>hr',       desc = 'Reset hunk' },
    { key = '<leader>hp',       desc = 'Preview hunk' },
    { key = '<leader>hb',       desc = 'Blame line (full)' },
    { key = '<leader>hd',       desc = 'Diff against index' },
    { key = '<leader>tb',       desc = 'Toggle inline blame' },
  }},
  { title = 'Buffers', items = {
    { key = ']b  [b',          desc = 'Cycle buffers' },
    { key = '<leader>bx',       desc = 'Close buffer' },
    { key = '<leader>bo',       desc = 'Close other buffers' },
    { key = '<leader>bp',       desc = 'Pin buffer' },
  }},
  { title = 'Diagnostics / Trouble', items = {
    { key = '<leader>xx',       desc = 'Workspace diagnostics' },
    { key = '<leader>xX',       desc = 'Buffer diagnostics' },
    { key = '<leader>xQ',       desc = 'Quickfix list' },
    { key = '<leader>q',        desc = 'Diagnostic loclist' },
  }},
  { title = 'Debug (DAP)', items = {
    { key = 'F5',               desc = 'Start / continue' },
    { key = 'F10',              desc = 'Step over' },
    { key = 'F11',              desc = 'Step into' },
    { key = 'F3',               desc = 'Step out' },
    { key = 'F7',               desc = 'Toggle DAP UI' },
    { key = '<leader>b',        desc = 'Toggle breakpoint' },
    { key = '<leader>B',        desc = 'Conditional breakpoint' },
  }},
  { title = 'Editing', items = {
    { key = '<leader>f',        desc = 'Format buffer' },
    { key = 'gcc  gc (visual)', desc = 'Comment line / selection' },
    { key = '<M-j>  <M-k>',    desc = 'Multi-cursor down / up' },
    { key = '<leader>a',        desc = 'Multi-cursor to cword' },
    { key = 'sa  sd  sr',       desc = 'Surround add/del/replace' },
    { key = '<leader>fff',      desc = 'Toggle f-string (Python)' },
  }},
  { title = 'Misc', items = {
    { key = '<leader>nm',       desc = 'Toggle minimap' },
    { key = '<leader>nl / nh',  desc = 'Noice last / history' },
    { key = 'F1',               desc = 'Cheatsheet (toggle window)' },
    { key = '<leader>?',        desc = 'Search keybinds (picker)' },
  }},
}

-- ── Floating window (M.toggle) ───────────────────────────────────────────────

local function rpad(s, w)
  local dw = vim.fn.strdisplaywidth(s)
  return dw >= w and s or (s .. string.rep(' ', w - dw))
end

local function build_content()
  local sections = M.sections
  local lines = {}
  local hls   = {} -- { lnum, byte_start, byte_end, hl_group }

  local function hl(lnum, bs, be, group)
    table.insert(hls, { lnum, bs, be, group })
  end

  local WIN_W = 2 * SEC_W + #GAP

  -- Header
  local hdr     = 'GRONK.NVIM  --  KEYBIND CHEATSHEET'
  local hdr_col = math.floor((WIN_W - #hdr) / 2)
  table.insert(lines, rpad(string.rep(' ', hdr_col) .. hdr, WIN_W))
  hl(0, hdr_col, hdr_col + #hdr, 'CheatsheetTitle')

  -- Divider (─ = 3 bytes / 1 display col; -1 = end of line)
  table.insert(lines, string.rep('─', WIN_W))
  hl(1, 0, -1, 'CheatsheetSep')

  local function render_sec(sec)
    local rows = {}
    table.insert(rows, {
      text = rpad('  ' .. sec.title, SEC_W),
      hls  = { { 0, -1, 'CheatsheetSection' } },
    })
    for _, item in ipairs(sec.items) do
      local indent   = 3
      local row_text = rpad(
        string.rep(' ', indent) .. rpad(item.key, KEY_W) .. ' ' .. item.desc,
        SEC_W
      )
      table.insert(rows, {
        text = row_text,
        hls  = {
          { indent, indent + #item.key, 'CheatsheetKey' },
          { indent + KEY_W + 1, indent + KEY_W + 1 + #item.desc, 'CheatsheetDesc' },
        },
      })
    end
    table.insert(rows, { text = rpad('', SEC_W), hls = {} })
    return rows
  end

  local empty_row = { text = rpad('', SEC_W), hls = {} }
  local right_off = SEC_W + #GAP

  for i = 1, #sections, 2 do
    local left    = render_sec(sections[i])
    local right   = sections[i + 1] and render_sec(sections[i + 1]) or {}
    local pair_h  = math.max(#left, #right)

    for j = 1, pair_h do
      local l    = left[j]  or empty_row
      local r    = right[j] or empty_row
      local lnum = #lines
      table.insert(lines, l.text .. GAP .. r.text)

      for _, lh in ipairs(l.hls) do
        local be = lh[2] == -1 and SEC_W or lh[2]
        hl(lnum, lh[1], be, lh[3])
      end
      for _, rh in ipairs(r.hls) do
        local be = rh[2] == -1 and right_off + SEC_W or right_off + rh[2]
        hl(lnum, right_off + rh[1], be, rh[3])
      end
    end
  end

  return lines, hls, WIN_W
end

local state = { win = nil }

function M.toggle()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
    return
  end

  local lines, hls, win_w = build_content()

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden  = 'wipe'
  vim.bo[buf].filetype   = 'cheatsheet'

  vim.api.nvim_set_hl(0, 'CheatsheetTitle',   { link = 'Title',    default = true })
  vim.api.nvim_set_hl(0, 'CheatsheetSep',     { link = 'Comment',  default = true })
  vim.api.nvim_set_hl(0, 'CheatsheetSection', { link = 'Function', default = true })
  vim.api.nvim_set_hl(0, 'CheatsheetKey',     { link = 'Keyword',  default = true })
  vim.api.nvim_set_hl(0, 'CheatsheetDesc',    { link = 'Comment',  default = true })

  for _, h in ipairs(hls) do
    vim.api.nvim_buf_add_highlight(buf, -1, h[4], h[1], h[2], h[3])
  end

  local win_h = math.min(#lines, vim.o.lines - 6)
  local row   = math.max(0, math.floor((vim.o.lines   - win_h) / 2) - 1)
  local col   = math.max(0, math.floor((vim.o.columns - win_w)  / 2))

  state.win = vim.api.nvim_open_win(buf, true, {
    relative  = 'editor',
    width     = win_w,
    height    = win_h,
    row       = row,
    col       = col,
    style     = 'minimal',
    border    = 'rounded',
    title     = '  Cheatsheet ',
    title_pos = 'center',
  })

  vim.wo[state.win].scrolloff  = 0
  vim.wo[state.win].cursorline = false
  vim.wo[state.win].wrap       = false

  local close = function()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
      vim.api.nvim_win_close(state.win, true)
      state.win = nil
    end
  end
  for _, key in ipairs { 'q', '<Esc>', '<F1>' } do
    vim.keymap.set('n', key, close, { buffer = buf, silent = true, nowait = true })
  end
end

-- ── Telescope picker (M.picker) ───────────────────────────────────────────────
-- Fuzzy-search all keybinds by key, description or section.
-- <Enter>  → notify with the binding as a reminder
-- <C-f>    → close picker and open the full floating window instead

function M.picker(opts)
  local ok = pcall(require, 'telescope')
  if not ok then
    vim.notify('Telescope not available — opening cheatsheet window instead', vim.log.levels.WARN)
    M.toggle()
    return
  end

  local pickers       = require 'telescope.pickers'
  local finders       = require 'telescope.finders'
  local tconf         = require('telescope.config').values
  local actions       = require 'telescope.actions'
  local action_state  = require 'telescope.actions.state'
  local entry_display = require 'telescope.pickers.entry_display'

  -- Flatten M.sections into a list of { section, key, desc }
  local entries = {}
  for _, section in ipairs(M.sections) do
    for _, item in ipairs(section.items) do
      table.insert(entries, {
        section = section.title,
        key     = item.key,
        desc    = item.desc,
      })
    end
  end

  local displayer = entry_display.create {
    separator = '  ',
    items = {
      { width = 24 }, -- section
      { width = 22 }, -- key
      { remaining = true }, -- desc
    },
  }

  local function make_display(entry)
    return displayer {
      { entry.section, 'Comment'  },
      { entry.key,     'Keyword'  },
      { entry.desc,    'Normal'   },
    }
  end

  pickers.new(opts or {}, {
    prompt_title  = '  Cheatsheet',
    results_title = 'section  ·  key  ·  description',
    finder = finders.new_table {
      results = entries,
      entry_maker = function(entry)
        return {
          value   = entry,
          display = make_display,
          -- search across all three fields
          ordinal = entry.section .. ' ' .. entry.key .. ' ' .. entry.desc,
          section = entry.section,
          key     = entry.key,
          desc    = entry.desc,
        }
      end,
    },
    sorter = tconf.generic_sorter(opts or {}),
    attach_mappings = function(prompt_bufnr, map)
      -- Enter: close and surface the binding as a notification reminder
      actions.select_default:replace(function()
        local sel = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if sel then
          vim.notify(
            '  ' .. sel.key,
            vim.log.levels.INFO,
            { title = sel.section .. '  ·  ' .. sel.desc }
          )
        end
      end)

      -- <C-f>: switch to the full floating window
      map({ 'i', 'n' }, '<C-f>', function()
        actions.close(prompt_bufnr)
        M.toggle()
      end)

      return true
    end,
  }):find()
end

return M
