-- Floating keybind cheatsheet + Telescope picker
--   M.toggle()      → plain floating window  (bound to <F1>)
--   M.toggle_nui()  → nui.Popup window       (bound to <leader>??)
--   M.picker()      → Telescope search       (bound to <leader>?)

local M = {}

-- ── Section data ─────────────────────────────────────────────────────────────
-- Exposed so alpha.lua and the Telescope picker can consume it.
-- Keep in sync with actual plugin keymaps.
M.sections = {
  { title = 'Navigation', items = {
    { key = 'Ctrl+h/j/k/l',   desc = 'Switch window' },
    { key = ']b  [b',         desc = 'Next / prev buffer' },
    { key = '<Space>t',       desc = 'Toggle file tree' },
    { key = '<C-d>  <C-u>',  desc = 'Scroll half-page down/up' },
    { key = 'gg  G',          desc = 'Top / bottom of file' },
    { key = '<C-o>  <C-i>',  desc = 'Jump back / forward' },
    { key = 'gd  K',          desc = 'Definition / hover docs' },
    { key = ']d  [d',         desc = 'Next / prev diagnostic' },
    { key = '*  #',           desc = 'Search word fwd / bwd' },
    { key = 'za  zR  zM',    desc = 'Toggle/open/close folds' },
  }},
  { title = 'Search (Telescope)', items = {
    { key = '<leader>sf',      desc = 'Find files' },
    { key = '<leader>sg',      desc = 'Live grep' },
    { key = '<leader>sw',      desc = 'Grep word under cursor' },
    { key = '<leader>/',       desc = 'Fuzzy search in buffer' },
    { key = '<leader><Space>', desc = 'Open buffers' },
    { key = '<leader>sh',      desc = 'Help tags' },
    { key = '<leader>sd',      desc = 'Search diagnostics' },
    { key = '<leader>sr',      desc = 'Resume last search' },
  }},
  { title = 'Completion (blink)', items = {
    { key = '<Tab>  <S-Tab>', desc = 'Select next / prev item' },
    { key = '<CR>',           desc = 'Accept item' },
    { key = '<C-space>',      desc = 'Open / close menu' },
    { key = '<C-e>',          desc = 'Dismiss menu' },
    { key = '<C-b>  <C-f>',  desc = 'Scroll docs up / down' },
  }},
  { title = 'Text Objects (mini.ai)', items = {
    { key = 'i  a',            desc = 'Inside / around (prefix)' },
    { key = '( [ { < " t b q', desc = 'Paren bracket quote tag' },
    { key = 'in  il',          desc = 'Next / last of same type' },
  }},
  { title = 'Git', items = {
    { key = ']h  [h',         desc = 'Next / prev hunk' },
    { key = '<leader>hs',     desc = 'Stage hunk' },
    { key = '<leader>hr',     desc = 'Reset hunk' },
    { key = '<leader>hp',     desc = 'Preview hunk' },
    { key = '<leader>hb',     desc = 'Blame line (full)' },
    { key = '<leader>hd',     desc = 'Diff against index' },
    { key = '<leader>tb',     desc = 'Toggle inline blame' },
  }},
  { title = 'Buffers', items = {
    { key = '<leader>bx',     desc = 'Close buffer' },
    { key = '<leader>bo',     desc = 'Close other buffers' },
    { key = '<leader>bp',     desc = 'Pin buffer' },
  }},
  { title = 'Diagnostics / Trouble', items = {
    { key = '<leader>xx',     desc = 'Workspace diagnostics' },
    { key = '<leader>xX',     desc = 'Buffer diagnostics' },
    { key = '<leader>xQ',     desc = 'Quickfix list' },
    { key = '<leader>q',      desc = 'Diagnostic loclist' },
  }},
  { title = 'Debug (DAP)', items = {
    { key = 'F5',             desc = 'Start / continue' },
    { key = 'F10',            desc = 'Step over' },
    { key = 'F11',            desc = 'Step into' },
    { key = 'F3',             desc = 'Step out' },
    { key = 'F7',             desc = 'Toggle DAP UI' },
    { key = '<leader>b',      desc = 'Toggle breakpoint' },
    { key = '<leader>B',      desc = 'Conditional breakpoint' },
  }},
  { title = 'Editing', items = {
    { key = '<leader>f',        desc = 'Format buffer' },
    { key = '<leader>rn',       desc = 'Rename symbol' },
    { key = '<leader>ca',       desc = 'Code action' },
    { key = 'gcc  gc (visual)', desc = 'Comment line / selection' },
    { key = '<M-j>  <M-k>',    desc = 'Multi-cursor down / up' },
    { key = '<leader>a',        desc = 'Multi-cursor to cword' },
    { key = 'sa  sd  sr',       desc = 'Surround add/del/replace' },
    { key = '<leader>fff',      desc = 'Toggle f-string (Python)' },
  }},
  { title = 'Misc', items = {
    { key = '<leader>nm',      desc = 'Toggle minimap' },
    { key = '<leader>nl / nh', desc = 'Noice last / history' },
    { key = 'F1',              desc = 'Toggle cheatsheet window' },
    { key = '<leader>??',      desc = 'Cheatsheet (nui popup)' },
  }},
}

-- ── Layout ───────────────────────────────────────────────────────────────────
-- Content-driven minimums (derived from actual section data above).
--   Longest key  = 'gcc  gc (visual)' = 16 chars
--   Longest desc = 'Comment line / selection' = 24 chars
local INDENT    = 3
local MIN_KEY_W = 16
local MIN_DESC  = 24
local MIN_SEC_W = INDENT + MIN_KEY_W + 1 + MIN_DESC  -- 44
local GAP       = ' │ '   -- 5 bytes (space + 3-byte │ + space), 3 display cols
local GAP_W     = 3       -- display width of GAP (avoids calling strdisplaywidth every time)
local BORDER_W  = 2       -- rounded border adds 1 col on each side

-- Returns a layout table computed from the current terminal width.
-- Called at open-time so the popup always fits the actual window.
local function compute_layout()
  local term_w = vim.o.columns
  -- Two-column needs: 2×content + gap + border ≥ terminal width
  if term_w >= 2 * MIN_SEC_W + GAP_W + BORDER_W then
    return {
      two_col  = true,
      sec_w    = MIN_SEC_W,             -- 44 — content cols per section
      key_w    = MIN_KEY_W,             -- 16
      max_desc = MIN_DESC,              -- 24
      win_w    = 2 * MIN_SEC_W + GAP_W, -- 91 display cols (popup content width)
    }
  end
  -- Single column: use all available space down to the minimum
  local sec_w    = math.max(term_w - BORDER_W, MIN_SEC_W)
  local max_desc = math.max(sec_w - INDENT - MIN_KEY_W - 1, 1)
  return {
    two_col  = false,
    sec_w    = sec_w,
    key_w    = MIN_KEY_W,
    max_desc = max_desc,
    win_w    = sec_w,
  }
end

-- ── Content builder ──────────────────────────────────────────────────────────
-- Returns { lines, hls } where:
--   lines  = list of strings ready for nvim_buf_set_lines
--   hls    = list of { lnum, byte_start, byte_end, hl_group }
-- All content (keys, descs, padding) is ASCII so byte == display col everywhere
-- except inside the GAP string itself (which contains the multi-byte │).
-- nvim_buf_add_highlight uses byte offsets; byte positions here are correct.

local function rpad(s, w)
  local dw = vim.fn.strdisplaywidth(s)
  return dw >= w and s or (s .. string.rep(' ', w - dw))
end

local function build_content(lo)
  local lines = {}
  local hls   = {}

  local function hl(lnum, bs, be, group)
    table.insert(hls, { lnum, bs, be, group })
  end

  -- Header
  local hdr     = 'GRONK.NVIM  --  KEYBIND CHEATSHEET'
  local hdr_col = math.floor((lo.win_w - #hdr) / 2)
  table.insert(lines, rpad(string.rep(' ', hdr_col) .. hdr, lo.win_w))
  hl(0, hdr_col, hdr_col + #hdr, 'CheatsheetTitle')

  -- Divider — ─ is 3 bytes / 1 display col; highlight end -1 means end of line
  table.insert(lines, string.rep('─', lo.win_w))
  hl(1, 0, -1, 'CheatsheetSep')

  -- Build rows for one section: { text, hls = {{bs, be, group}, ...} }
  local function sec_rows(sec)
    if not sec then return {} end
    local rows = {}
    -- Title row
    table.insert(rows, {
      text = rpad('  ' .. sec.title, lo.sec_w),
      hls  = { { 0, -1, 'CheatsheetSection' } },
    })
    -- Item rows
    for _, item in ipairs(sec.items) do
      local desc = item.desc:sub(1, lo.max_desc)
      table.insert(rows, {
        text = rpad(string.rep(' ', INDENT) .. rpad(item.key, lo.key_w) .. ' ' .. desc, lo.sec_w),
        hls  = {
          { INDENT,                         INDENT + #item.key,                     'CheatsheetKey'  },
          { INDENT + lo.key_w + 1,          INDENT + lo.key_w + 1 + #desc,          'CheatsheetDesc' },
        },
      })
    end
    -- Blank separator
    table.insert(rows, { text = rpad('', lo.sec_w), hls = {} })
    return rows
  end

  local empty = { text = rpad('', lo.sec_w), hls = {} }

  if lo.two_col then
    -- right_off: byte offset to the start of the right column.
    -- sec_w is ASCII so sec_w bytes = sec_w display cols.
    -- #GAP = 5 bytes (' │ ' = 1 + 3 + 1).
    local right_off = lo.sec_w + #GAP

    for i = 1, #M.sections, 2 do
      local left  = sec_rows(M.sections[i])
      local right = sec_rows(M.sections[i + 1])
      local ph    = math.max(#left, #right)

      for j = 1, ph do
        local l    = left[j]  or empty
        local r    = right[j] or empty
        local lnum = #lines
        table.insert(lines, l.text .. GAP .. r.text)

        for _, lh in ipairs(l.hls) do
          hl(lnum, lh[1], lh[2] == -1 and lo.sec_w or lh[2], lh[3])
        end
        -- Highlight the │ separator (bytes sec_w to sec_w + #GAP)
        hl(lnum, lo.sec_w, lo.sec_w + #GAP, 'CheatsheetSep')
        for _, rh in ipairs(r.hls) do
          hl(lnum, right_off + rh[1],
            rh[2] == -1 and right_off + lo.sec_w or right_off + rh[2], rh[3])
        end
      end
    end
  else
    -- Single column: stack sections vertically
    for _, sec in ipairs(M.sections) do
      for _, row in ipairs(sec_rows(sec)) do
        local lnum = #lines
        table.insert(lines, row.text)
        for _, h in ipairs(row.hls) do
          hl(lnum, h[1], h[2] == -1 and lo.sec_w or h[2], h[3])
        end
      end
    end
  end

  return lines, hls
end

local function set_highlights()
  vim.api.nvim_set_hl(0, 'CheatsheetTitle',   { link = 'Title',    default = true })
  vim.api.nvim_set_hl(0, 'CheatsheetSep',     { link = 'Comment',  default = true })
  vim.api.nvim_set_hl(0, 'CheatsheetSection', { link = 'Function', default = true })
  vim.api.nvim_set_hl(0, 'CheatsheetKey',     { link = 'Keyword',  default = true })
  vim.api.nvim_set_hl(0, 'CheatsheetDesc',    { link = 'Comment',  default = true })
end

-- ── M.toggle — plain floating window (F1) ────────────────────────────────────

local state = { win = nil }

function M.toggle()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
    return
  end

  local lo           = compute_layout()
  local lines, hls   = build_content(lo)
  set_highlights()

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  for _, h in ipairs(hls) do
    vim.api.nvim_buf_add_highlight(buf, -1, h[4], h[1], h[2], h[3])
  end
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden  = 'wipe'
  vim.bo[buf].filetype   = 'cheatsheet'

  local win_h = math.min(#lines, vim.o.lines - 6)
  local row   = math.max(0, math.floor((vim.o.lines   - win_h) / 2) - 1)
  local col   = math.max(0, math.floor((vim.o.columns - lo.win_w - BORDER_W) / 2))

  state.win = vim.api.nvim_open_win(buf, true, {
    relative  = 'editor',
    width     = lo.win_w,
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

-- ── M.toggle_nui — nui.Popup window (<leader>??) ─────────────────────────────
-- Uses the same build_content() / highlight approach as M.toggle().
-- nui.Popup replaces the manual nvim_open_win call and handles centering;
-- no nui.Line / nui.Text (those caused colour bleed and scroll-drift).

local nui_state = { popup = nil }

function M.toggle_nui()
  if nui_state.popup then
    if nui_state.popup.winid and vim.api.nvim_win_is_valid(nui_state.popup.winid) then
      nui_state.popup:unmount()
    end
    nui_state.popup = nil
    return
  end

  local ok, Popup = pcall(require, 'nui.popup')
  if not ok then
    vim.notify('nui.nvim not available — falling back to M.toggle()', vim.log.levels.WARN)
    M.toggle()
    return
  end

  local lo           = compute_layout()
  local lines, hls   = build_content(lo)
  set_highlights()

  local win_h = math.min(#lines, vim.o.lines - 6)

  local popup = Popup {
    position = '50%',
    size     = { width = lo.win_w, height = win_h },
    border   = {
      style = 'rounded',
      text  = { top = '  Cheatsheet ', top_align = 'center' },
    },
    buf_options = { modifiable = true, readonly = false, filetype = 'cheatsheet' },
    win_options = { cursorline = false, wrap = false, scrolloff = 0 },
  }

  popup:mount()
  nui_state.popup = popup

  local buf = popup.bufnr
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local ns = vim.api.nvim_create_namespace 'cheatsheet_nui'
  for _, h in ipairs(hls) do
    vim.api.nvim_buf_add_highlight(buf, ns, h[4], h[1], h[2], h[3])
  end
  vim.bo[buf].modifiable = false

  local function close()
    if nui_state.popup then
      if nui_state.popup.winid and vim.api.nvim_win_is_valid(nui_state.popup.winid) then
        nui_state.popup:unmount()
      end
      nui_state.popup = nil
    end
  end

  popup:on(require('nui.utils.autocmd').event.BufWipeout, function()
    nui_state.popup = nil
  end)

  for _, key in ipairs { 'q', '<Esc>', '<leader>??' } do
    popup:map('n', key, close, { noremap = true, silent = true, nowait = true })
  end
end

-- ── M.picker — Telescope fuzzy search (<leader>?) ────────────────────────────
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

  local entries = {}
  for _, section in ipairs(M.sections) do
    for _, item in ipairs(section.items) do
      table.insert(entries, { section = section.title, key = item.key, desc = item.desc })
    end
  end

  local displayer = entry_display.create {
    separator = '  ',
    items = { { width = 24 }, { width = 22 }, { remaining = true } },
  }

  local function make_display(entry)
    return displayer {
      { entry.section, 'Comment' },
      { entry.key,     'Keyword' },
      { entry.desc,    'Normal'  },
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
          ordinal = entry.section .. ' ' .. entry.key .. ' ' .. entry.desc,
          section = entry.section,
          key     = entry.key,
          desc    = entry.desc,
        }
      end,
    },
    sorter = tconf.generic_sorter(opts or {}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local sel = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if sel then
          vim.notify('  ' .. sel.key, vim.log.levels.INFO,
            { title = sel.section .. '  ·  ' .. sel.desc })
        end
      end)
      map({ 'i', 'n' }, '<C-f>', function()
        actions.close(prompt_bufnr)
        M.toggle()
      end)
      return true
    end,
  }):find()
end

return M
