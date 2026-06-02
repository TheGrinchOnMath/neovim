# Authoring cheatsheet sections

The cheatsheet (`<F1>` / `<leader>??` / `<leader>?`) renders from a list of
**sections**. Each section is a standalone Lua file, so adding or editing one
never touches the rendering engine.

- **Engine:** [`lua/config/cheatsheet/init.lua`](../lua/config/cheatsheet/init.lua)
- **Section files:** [`lua/config/cheatsheet/sections/`](../lua/config/cheatsheet/sections/)

---

## How loading works

On `require('config.cheatsheet')`, the engine:

1. Globs `lua/config/cheatsheet/sections/*.lua` via `nvim_get_runtime_file`.
2. Sorts the results **by filename** — so a numeric prefix controls display order.
3. `require`s each file and validates it has `title` + `items`.
4. Collects them into `M.sections`, the single source of truth shared by the
   floating window, the `nui` popup, and the Telescope picker.

```text
sections/10-navigation.lua   ┐
sections/20-search.lua       ├─→  M.sections  ─→  toggle() / toggle_nui() / picker()
sections/55-neogit.lua       ┘
```

> An invalid file (missing `title`/`items`) is **skipped with a warning**, not a
> crash — the rest of the cheatsheet still loads.

---

## Add a new section — 3 steps

### 1. Create the file

Name it `NN-topic.lua`, where `NN` is a two-digit prefix that places it in the
list. Leave gaps (10, 20, 30…) so you can insert between later.

```lua
-- lua/config/cheatsheet/sections/45-harpoon.lua
-- Cheatsheet section: Harpoon (quick file marks)
-- Bindings live in lua/plugins/harpoon.lua.
return {
  title = 'Harpoon',
  items = {
    { key = '<leader>ha', desc = 'Add file to list' },
    { key = '<leader>hh', desc = 'Toggle quick menu' },
    { key = '<C-1>  <C-2>', desc = 'Jump to slot 1 / 2' },
  },
}
```

That's it. Reopen the cheatsheet and the section appears between
`40-text-objects` and `50-git`.

### 2. Mind the column widths

The layout is **content-driven** — it sizes columns from constants in the engine:

| Constant | Value | Meaning |
|---|---|---|
| `MIN_KEY_W` | `16` | Key column width; **longest `key` must fit** |
| `MIN_DESC` | `24` | Description column; longer text is **truncated** |

Keep `key` ≤ 16 display columns and `desc` ≤ 24. Longer descriptions won't break
the layout (there's a truncation guard) but they will be clipped. If you genuinely
need a wider key, bump `MIN_KEY_W` in the engine and re-check the two-column fit.

### 3. Verify

```sh
nvim --headless --clean -c "set rtp+=." \
  -c "lua local m=require('config.cheatsheet'); for _,s in ipairs(m.sections) do print(s.title) end" \
  -c "qa!"
```

Your new title should appear in the right position.

---

## Conventions

- **One topic per file.** Group by plugin or by theme, matching how a user thinks
  about the keys — not by where the code lives.
- **Document the source.** Add a top comment pointing at the file that actually
  defines the bindings (e.g. `-- Bindings in lua/plugins/foo.lua`). The cheatsheet
  describes; it does **not** define keymaps.
- **`key` is display text, not a literal mapping.** `']t  [t'` and
  `'<C-1>  <C-2>'` are fine — they're rendered verbatim.
- **Keep it in sync.** When you add/change a real keymap in a plugin spec, update
  (or add) its section here in the same commit.

---

## Section schema

```lua
return {
  title = string,            -- section header, shown in all three views
  items = {                  -- ordered list of rows
    { key = string,          -- left column: the keys (≤ 16 cols)
      desc = string },       -- right column: what they do (≤ 24 cols)
    ...
  },
}
```

| Field | Type | Required | Notes |
|---|---|---|---|
| `title` | `string` | ✅ | Missing → file skipped with a warning |
| `items` | `list` | ✅ | Order is preserved as written |
| `items[].key` | `string` | ✅ | Display width budget: 16 cols |
| `items[].desc` | `string` | ✅ | Display width budget: 24 cols (clipped beyond) |

---

## Removing or reordering

- **Remove:** delete the file. Nothing else references it.
- **Reorder:** rename the numeric prefix. Order is purely lexical on filename.
- **Rename a topic:** change `title` inside the file; the prefix can stay.
