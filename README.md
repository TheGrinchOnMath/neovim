# GRONK.NVIM

A personal Neovim configuration built on a [lazy.nvim](https://github.com/folke/lazy.nvim)
plugin layout, with a built-in, **modular keybind cheatsheet**.

> No mouse required. `:Lazy` to manage plugins, `<F1>` for the cheatsheet.

---

## Layout

```text
init.lua                     -- entry point: leader keys, then require config.*
lua/
├── config/
│   ├── opt.lua              -- vim options
│   ├── keymap.lua           -- global, non-plugin keymaps (see below)
│   ├── lsp.lua
│   └── cheatsheet/          -- the cheatsheet UI + its section data
│       ├── init.lua         -- rendering engine + Telescope picker
│       └── sections/        -- one file per topic (auto-loaded, ordered)
│           ├── 10-navigation.lua
│           ├── 20-search.lua
│           └── …
└── plugins/                 -- one file per plugin; each returns a lazy spec
    ├── neogit.lua
    ├── todo-comments.lua
    └── …
doc/
└── cheatsheet.md            -- how to add a cheatsheet section
manifests/                   -- (Phase 3) fresh-install dependency manifests
```

---

## Where keybinds are defined

Keybinds live next to the thing they control. There is **no single keymap file** —
look in the place that owns the behaviour:

| Binding(s) | Defined in | Notes |
|---|---|---|
| `<C-h/j/k/l>`, window resize, `<Esc>` clear search, `s`/`S` unbind | [`lua/config/keymap.lua`](lua/config/keymap.lua) | Global, plugin-independent maps. |
| `<F1>`, `<leader>?`, `<leader>??` (cheatsheet) | [`lua/config/keymap.lua`](lua/config/keymap.lua) | Guarded by `if not vim.g.vscode`. |
| `gd`, `gr`, `gI`, `gD`, `K`, `<leader>D`, `<leader>ds`, `<leader>ws`, `<leader>rn`, `<leader>ca`, `<leader>th` | [`lua/plugins/nvim-lspconfig.lua`](lua/plugins/nvim-lspconfig.lua) | **Buffer-local**, set in the `LspAttach` autocmd — only live once an LSP attaches. |
| `]h`, `[h`, `<leader>h*`, `<leader>tb`, `<leader>td` | [`lua/plugins/gitsigns.lua`](lua/plugins/gitsigns.lua) | Hunk staging/preview/blame. |
| `<leader>gg`, `<leader>gd`, `<leader>gD`, `<leader>gq` | [`lua/plugins/neogit.lua`](lua/plugins/neogit.lua) | `keys =` table → lazy-loads Neogit + Diffview. |
| `]t`, `[t`, `<leader>st` | [`lua/plugins/todo-comments.lua`](lua/plugins/todo-comments.lua) | Set in `config`; **not** plugin defaults. |
| `<leader>zp` (fold peek) | [`lua/plugins/nvim-ufo.lua`](lua/plugins/nvim-ufo.lua) | Avoids the `K`/LSP-hover clash; falls back to hover off a fold. |
| `<leader>sf/sg/sw/sd/sh/sr`, `<leader>/`, `<leader><Space>` | [`lua/plugins/telescope.lua`](lua/plugins/telescope.lua) | Search pickers. |
| `<leader>x*`, `<leader>q` | [`lua/plugins/trouble.lua`](lua/plugins/trouble.lua) | Diagnostics list. |
| `F5/F10/F11/F3/F7`, `<leader>b`, `<leader>B` | [`lua/plugins/debug.lua`](lua/plugins/debug.lua) | DAP. |
| `<M-j>`/`<M-k>`, `<leader>a` | [`lua/plugins/multiple-cursors.lua`](lua/plugins/multiple-cursors.lua) | Multi-cursor. |
| `which-key` prefix groups (`<leader>g`, `<leader>z`, …) | [`lua/plugins/which-key.lua`](lua/plugins/which-key.lua) | Labels only — the actual maps live in the files above. |

> **Rule of thumb:** if a binding belongs to a plugin, it is set in that plugin's
> spec under `lua/plugins/`. Only truly global maps go in `keymap.lua`.

---

## The cheatsheet

Three ways to view the same data (the `M.sections` table):

| Trigger | Function | UI |
|---|---|---|
| `<F1>` | `toggle()` | Plain floating window |
| `<leader>??` | `toggle_nui()` | `nui.Popup` window |
| `<leader>?` | `picker()` | Telescope fuzzy search |

The data is **modular**: every section is its own file in
[`lua/config/cheatsheet/sections/`](lua/config/cheatsheet/sections/), auto-loaded in
filename order. **To add one, drop in a new file** — no edit to the engine.

➡️ See [**doc/cheatsheet.md**](doc/cheatsheet.md) for the full authoring guide.

---

## Trying this config side-by-side (`nvc`)

Run this config without disturbing a default `nvim` setup, using `NVIM_APPNAME`
+ `XDG_CONFIG_HOME`. On Windows both are needed, because nvim defaults its
config root to `%LOCALAPPDATA%`, not `~/.config`:

```powershell
# one-time: clone the dev branch to the config location
git clone -b claude-dev https://github.com/TheGrinchOnMath/neovim `
  "$env:USERPROFILE\.config\nvim-claude"
```

Add a launcher to your PowerShell profile (`notepad $PROFILE`):

```powershell
function nvc {
    $env:NVIM_APPNAME    = 'nvim-claude'                 # → config dir leaf name
    $env:XDG_CONFIG_HOME = "$env:USERPROFILE\.config"    # → root it under ~/.config
    & nvim @args
}
```

| stdpath | resolves to | isolated? |
|---|---|---|
| `config` | `~\.config\nvim-claude` | ✅ separate from default |
| `data` / `state` | `%LOCALAPPDATA%\nvim-claude-data` | ✅ own lazy plugins, lock, shada |

`nvc` opens the test config; plain `nvim` stays default. Reload the profile
(`. $PROFILE`) after editing it.

> **Native dependencies:** parser compilation (nvim-treesitter `main`) and
> `telescope-fzf-native` require a **C compiler** (`gcc`/`clang`/`zig`) on PATH —
> `make` and `node` alone are not enough. Without one, parsers re-download on
> every startup and fzf-native falls back to the Lua sorter. See `manifests/`.

## Test / dev workflow

Edit locally, then validate without a UI:

```sh
# Load the cheatsheet module and list sections (sanity check the loader)
nvim --headless --clean -c "set rtp+=." \
  -c "lua local m=require('config.cheatsheet'); print(#m.sections)" -c "qa!"

# Syntax-check a single file
nvim --headless --clean -c "lua assert(loadfile('lua/plugins/neogit.lua'))" -c "qa!"
```
