# GRONK.NVIM — Claude Instance Handoff

## Workspace

| Resource | Value |
|---|---|
| Repo | https://github.com/thegrinchonmath/neovim |
| Active branch | `claude-dev` |
| Local folder | `C:\Users\j.wakeman\Claude\neovim-dotfiles` |
| Windows host | Win11 IoT-class · scoop nvim **v0.12.2** (single install; Program Files copy removed) |
| Side-by-side test config | `%USERPROFILE%\.config\nvim-claude`, launched with the `nvc` PowerShell function |
| Remote test machine | `raffpcadmin@172.21.22.180` · Fedora Server 44 · nvim v0.12.2 |

**Workflow:** edit locally in the folder above, commit and push to `claude-dev` from
PowerShell (`git` works directly — no Bash needed). Test on the Windows host via
`nvc` (sets `NVIM_APPNAME=nvim-claude` + `XDG_CONFIG_HOME=%USERPROFILE%\.config`),
or pull on the remote (`~/.config/nvim/`). Interactive nvim can't run in the agent
shell — validate headless: `nvc --headless -c "lua vim.cmd('messages')" -c "qa!"`.

---

## Status — Phases 1–3 complete

### Phase 1 — modular cheatsheet ✅ (`fa3218b`)
- `lua/config/cheatsheet.lua` → `lua/config/cheatsheet/init.lua`; section data split into
  auto-loaded `sections/NN-*.lua` files. `M.sections` is still the public contract.
- New bindings in their owning plugin specs: `<leader>gg` (Neogit), `<leader>gd/gD/gq`
  (Diffview), `]t/[t/<leader>st` (todo-comments, explicit), `<leader>zp` (ufo fold-peek,
  falls back to LSP hover). which-key groups for `<leader>g` and `<leader>z`.
- New sections: Neogit, Diffview, LSP/Symbols, Todo Comments.
- Docs: `README.md` (keybind-location map + `nvc` guide) and `doc/cheatsheet.md`
  (section authoring guide).

### Phase 2 — Windows testing ✅ (`8092b26`, `1c7e946`)
- **Fixed** treesitter crash: spec used the `main`-branch `install()` API but didn't pin
  the branch; a stale lock checked out `master`. Added `branch = 'main'` + re-synced.
- **Toolchain**: installed `gcc` (15.2.0) and the **`tree-sitter` CLI** (0.26.9) via scoop.
  nvim-treesitter `main` runs `tree-sitter build`, so a C compiler alone is insufficient.
  After: all 19 parsers compile, `libfzf.dll` builds, startup ~640 → ~417 ms.
- Verified all new keymaps fire; Mason installs all 14 servers/formatters (ruff + goimports
  each needed a one-off reinstall after a transient batch failure); installed `fd`.
- Disabled unused perl/ruby/node/python3 providers → `:checkhealth provider` is clean.

### Phase 3 — fresh-install manifests ✅ (`0acbc45`)
- `manifests/scoopfile.json` (`scoop import`), `install.ps1` (`-Target default|claude`,
  non-admin, idempotent), `provision.lua` (headless plugins + parsers + Mason), `README.md`.
- Reconciled `scoop/dnf/apt/winget` lists with the validated dep set (key: tree-sitter CLI).
- dnf5 one-liner: `sudo dnf5 install $(sed 's/#.*//' manifests/dnf.txt)`.
- **Caveat:** not run end-to-end on a truly fresh IoT image — static- and
  component-verified only.

---

## Windows C-toolchain quirks (read before changing the rust/build story)

The manifests install **mingw `gcc`** as the C compiler, which is what nvim-treesitter
and `telescope-fzf-native` use. This sidesteps MSVC entirely. If anything is switched to
the MSVC toolchain, mind these:

- **`rustup` defaults to the MSVC host triple** (`stable-x86_64-pc-windows-msvc`). That
  toolchain needs the **MSVC linker (`link.exe`) + the Windows SDK** to actually *link*
  binaries — neither ships with Windows or with scoop's `rustup`. Without them, `cargo
  build` fails at the link step (rustc/`rust_analyzer` checking still works, and
  `rust_analyzer` itself is a Mason-prebuilt binary, so the editor is fine).
- To compile Rust on this box without a heavy Visual Studio install, switch to the GNU
  toolchain that reuses the mingw gcc we already install:
  `rustup default stable-x86_64-pc-windows-gnu`.
- The MSVC alternative is **Visual Studio Build Tools** with two components:
  *"MSVC v143 — VS C++ build tools"* (gives `cl.exe`/`link.exe`) **and** the
  *"Windows 10/11 SDK"* (headers + import libs). That's a large, partly-GUI installer —
  avoided here precisely because the goal is a non-interactive, no-DWM provision.
- `telescope-fzf-native` builds with `gcc -shared` + `make`; it does **not** need MSVC.
  Treesitter parsers compile via `tree-sitter build`, which shells out to the C compiler
  on PATH (gcc) — also no MSVC needed.

Bottom line: **stay on mingw gcc.** MSVC buys nothing the config needs and pulls in the
SDK + an interactive installer.

---

## Deferred / open items

### 1. nvim_buf_add_highlight → extmark migration
`lua/config/cheatsheet/init.lua` still uses `nvim_buf_add_highlight` (soft-deprecated in
0.11, works in 0.12.2). Move to `nvim_buf_set_extmark`. Gotcha: the old `col_end = -1`
("to end of line") sentinel is invalid for extmarks — use `end_row = line+1, end_col = 0`
(or `hl_eol = true`). Affects the divider line and section-title rows (`lh[2] == -1`
branches, `hl(1, 0, -1, ...)`). Contained: everything funnels through one `hl()` helper +
two apply loops (in `M.toggle` and `M.toggle_nui`). Re-run the headless render check after.

### 2. Help-pane navigator (still deferred, design only)
Decompose the monolithic cheatsheet into per-topic panes. Three sketched options remain on
the table; none implemented:
- **A — Section navigator:** nui `Layout`, left list + right detail pane, `j/k` to move.
  Recommended starting point; `M.sections` already supports it with no refactor.
- **B — Per-section quick-open:** direct `<leader>?<x>` bindings via `M.section_popup(title)`.
- **C — Tabbed single window:** `]`/`[` cycle topic tabs (heavier; tab bar eats a line).

### 3. Minor
- `fd` is now installed but `goimports`/`ruff` reinstalls were transient — if a fresh
  provision shows them missing, just re-run `provision.lua` (idempotent).
- The host's scoop `extras` bucket was repaired once (stale local source, 0 manifests);
  if extras apps go "NOT FOUND", `scoop bucket rm extras; scoop bucket add extras`.
