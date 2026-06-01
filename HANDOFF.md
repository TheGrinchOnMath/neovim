# GRONK.NVIM — Claude Instance Handoff

## Workspace

| Resource | Value |
|---|---|
| Repo | https://github.com/thegrinchonmath/neovim |
| Active branch | `claude-dev` |
| Local folder | `C:\Users\j.wakeman\Claude\neovim-dotfiles` |
| Remote test machine | `raffpcadmin@172.21.22.180` |
| Remote OS / nvim | Fedora Server 44 · nvim v0.12.2 |

**Workflow:** edit locally in the folder above, commit and push to `claude-dev` from
PowerShell (`git` works directly — no Bash needed). Pull on the remote to test.
The remote's nvim config lives at `~/.config/nvim/`.

---

## Pending suggestions

These plugins are installed and active but have no cheatsheet coverage yet.
Each is a self-contained task.

### 1. neogit — full git UI
No keybind is mapped to open it yet.  Suggested: `<leader>gg`.
Default internal bindings once open:

| Key | Action |
|---|---|
| `s` / `u` | Stage / unstage file or hunk |
| `cc` | Commit |
| `Fp` / `Fl` | Push / pull |
| `d` | Open diffview for file |
| `b` | Branch management |
| `q` | Close |

**Task:** add `<leader>gg` → `:Neogit<CR>` in `keymap.lua`, add a `Neogit` section to
`cheatsheet.lua`.

### 2. todo-comments — jump and search TODOs
Plugin is installed with default bindings only (no explicit `keys = {}` in the config).

| Key | Action |
|---|---|
| `]t` / `[t` | Next / prev TODO comment |
| `<leader>st` | Telescope search all TODOs |

**Task:** add a `Todo Comments` section to `cheatsheet.lua`. Optionally wire the
bindings explicitly in `keymap.lua` so they appear in which-key.

### 3. LSP extras
These were removed when the LSP block was dropped from the cheatsheet but they are
still mapped in `nvim-lspconfig.lua`:

| Key | Action |
|---|---|
| `gr` | References (Telescope) |
| `gI` | Go to implementation |
| `gD` | Go to declaration |
| `<leader>D` | Type definition |
| `<leader>ds` | Document symbols |
| `<leader>ws` | Workspace symbols |
| `<leader>th` | Toggle inlay hints |

**Task:** decide which subset is worth surfacing; add a compact `LSP / Symbols`
section (4–6 entries) to `cheatsheet.lua`.

### 4. diffview — side-by-side diffs
Installed as a neogit dependency (`sindrets/diffview.nvim`). No bindings configured.

| Key | Action |
|---|---|
| `:DiffviewOpen [rev]` | Open diff against rev (default: index) |
| `:DiffviewFileHistory` | File or range history |
| `<Tab>` / `<S-Tab>` | Next / prev changed file |
| `q` | Close |

**Task:** add explicit open/close bindings in `keymap.lua`, document in cheatsheet.

### 5. nvim-ufo — fold peek
`ufo` is configured with `require('ufo').setup()` — no custom keybinds.  The default
`K` to peek fold content conflicts with LSP hover (also `K`).

**Task:** bind fold-peek to something non-conflicting (e.g. `<leader>zp`) in the ufo
setup call, add to the Navigation section of the cheatsheet.

---

## Help-pane concept draft

The current cheatsheet is a single monolithic view (two-column, all sections at once).
As coverage grows the popup gets taller and harder to scan.  The idea is to decompose
it into **per-plugin or per-topic panes** that can be opened individually.

### Option A — Section navigator (recommended starting point)

A nui `Layout` with two side-by-side `Popup` windows:

```
╭── Sections ──────╮╭── Detail ──────────────────────────────────────────────╮
│  Navigation      ││  Navigation                                             │
│  Search          ││   <C-d>  <C-u>   Scroll half-page down/up              │
│  Completion      ││   gd  K          Definition / hover docs               │
│▶ Git             ││   ]d  [d         Next / prev diagnostic                │
│  Buffers         ││   …                                                     │
│  …               ││                                                         │
╰──────────────────╯╰─────────────────────────────────────────────────────────╯
```

- Left pane: section titles, navigable with `j`/`k`.
- Right pane: full detail for the highlighted section — no column width limit,
  room for examples, notes, longer descriptions.
- `<CR>` or `<Esc>` close; `<C-f>` or `<F1>` switch back to the compact overview.
- `M.sections` is already the single source of truth — the navigator just
  renders one section at a time into the right pane.
- Bind to `<leader>?s` (s for sections) or replace `<leader>??`.

### Option B — Per-plugin quick-open bindings

Each section gets a direct two-key binding:

| Binding | Opens |
|---|---|
| `<leader>?n` | Navigation pane |
| `<leader>?g` | Git pane |
| `<leader>?c` | Completion pane |
| `<leader>?d` | Debug pane |
| … | … |

Implemented as `M.section_popup(title)` — filters `M.sections` by title, renders
single-column in a centred popup.  Fast to implement on top of the existing
`build_content()` logic (pass a single-section layout).

### Option C — Tabbed single window

One floating window with a tab bar across the top:

```
╭─ Navigation ─┬─ Search ─┬─ Git ─┬─ … ─────────────────────╮
│  Ctrl+h/…    │          │       │                           │
│  ]b  [b      │          │       │                           │
```

`]` / `[` cycle tabs.  Heavier to implement; the tab bar eats 1 line of height.

### Implementation notes

- `nui.Popup` is already in use and working — use it for both panes in Option A.
- The `M.sections` table is public so all three options are additive (no refactor).
- The `M.picker()` Telescope integration already provides fuzzy search across all
  sections; the navigator pane complements it rather than replacing it.

---

## Session recap

All commits are on the `claude-dev` branch.

### `ccd50d0` — fix(cheatsheet): correct column overflow

`KEY_W = 19` left only 21 chars for descriptions; 6 rows were wider than `SEC_W = 44`,
pushing the column divider and right column off-screen.  Fixed by reducing `KEY_W` to
16 (the actual longest key), shortening one description, and adding a `max_desc`
truncation guard so future additions cannot silently break the layout.

### `1df753b` — feat(cheatsheet): nui.Popup toggle (`<leader>??`)

Added `M.toggle_nui()` using `nui.Line` / `nui.Text` for highlight-aware rendering
and `nui.Popup` for the window.  The separator was upgraded from the ASCII `  |  ` to
a Unicode ` │ `.

### `8376320` — refactor(cheatsheet): responsive layout + fix nui rendering

`nui.Line` / `nui.Text` rendered text chunk-by-chunk; extmark byte offsets went wrong
when multi-byte chars were present, causing colour bleed and visual position drift
while scrolling.  Replaced with plain `nvim_buf_set_lines` + `nvim_buf_add_highlight`
(the same approach used by the original `M.toggle()`).  `nui.Popup` was kept for
window creation and centering (`position = '50%'`).

Also introduced `compute_layout()`: reads `vim.o.columns` at open-time and returns
either a two-column layout (≥ 93 cols) or a single-column fallback.  Both toggle
functions use it so the popup always fits the actual terminal.

### `394ff21` — fix(cheatsheet) + fix(bufferline)

**Cheatsheet:** dropped the LSP block (between Navigation and Search in the rendered
view), removed the duplicate `]b  [b` from Buffers, removed the meta `<leader>?`
self-reference from Misc.  Navigation gained `<C-d>/<C-u>` scroll, `gd/K`,
`]d/[d` diagnostics, `*/#` word search, and `za/zR/zM` folds.  Rename and code-action
moved from the deleted LSP section into Editing.  `<leader>??` added to Misc.

**Bufferline:** the highlights block was targeting `tab_separator` /
`tab_separator_selected`, which only apply in `mode = "tabs"`.  The config uses
`mode = "buffers"`, so those groups were silently ignored and the slant-separator
corners remained white.  Replaced with `separator`, `separator_selected`, and
`separator_visible`.

### `f2c21f3` — feat(cheatsheet): Completion and Text Objects sections

Added **Completion (blink)** covering the `super-tab` preset (Tab/S-Tab, CR, C-space,
C-e, C-b/C-f) and **Text Objects (mini.ai)** covering the inside/around prefix,
available objects, and the next/last modifier — three compact rows.  The two new
sections pair together on row 2 of the two-column layout.
