# Dependency manifests

Everything needed to take a fresh machine to a working gronk.nvim. The Windows
path is **scoop-first and fully non-interactive** (no DWM/GUI prompts); the
Linux paths are package lists for the native package manager.

| File | Platform | Role |
|---|---|---|
| [`scoopfile.json`](scoopfile.json) | Windows | `scoop import` manifest — buckets + apps |
| [`install.ps1`](install.ps1) | Windows | One-shot bootstrap (scoop → deps → clone → provision) |
| [`provision.lua`](provision.lua) | any | Headless nvim step: plugins + parsers + Mason tools |
| [`scoop.txt`](scoop.txt) | Windows | Human-readable package reference (mirrors the JSON) |
| [`dnf.txt`](dnf.txt) | Fedora / RHEL | DNF package list |
| [`apt.txt`](apt.txt) | Debian / Ubuntu | APT package list |
| [`winget.txt`](winget.txt) | Windows (alt) | winget reference (scoop is preferred) |

---

## Windows (Win11 / IoT LTSC) — recommended

Run from a **normal, non-elevated** PowerShell (scoop is a per-user tool and the
script refuses to run as admin):

```powershell
# get the repo, then bootstrap everything
git clone -b claude-dev https://github.com/TheGrinchOnMath/neovim "$env:TEMP\gronk"
cd "$env:TEMP\gronk"
.\manifests\install.ps1                  # primary config  -> launch with `nvim`
# or, side-by-side test config:
.\manifests\install.ps1 -Target claude   # -> launch with `nvc`
```

`install.ps1` is idempotent. It installs scoop + git, runs
`scoop import scoopfile.json` (neovim, gcc, **tree-sitter CLI**, make, ripgrep,
fd, node, python, go, rustup, Windows Terminal, JetBrainsMono Nerd Font), clones
the config, and runs `provision.lua` headless.

> **Why `tree-sitter` and `gcc` are both required:** nvim-treesitter's `main`
> branch compiles parsers by running `tree-sitter build` — a C compiler alone is
> not enough.

### Manual scoop route (without install.ps1)

```powershell
scoop bucket add extras
scoop bucket add nerd-fonts
scoop import .\manifests\scoopfile.json
nvim --headless -c "luafile .\manifests\provision.lua" -c "qa!"
```

---

## Fedora / RHEL (dnf5)

Strip comments and feed the list straight to dnf5:

```bash
sudo dnf5 install $(sed 's/#.*//' manifests/dnf.txt)
# fully unattended:
sudo dnf5 -y install $(sed 's/#.*//' manifests/dnf.txt)
```

`sed 's/#.*//'` drops both full-line and inline comments, leaving only package
names. Then provision the editor:

```bash
nvim --headless -c "luafile manifests/provision.lua" -c "qa!"
```

> On older RHEL/EPEL without a `tree-sitter-cli` rpm, install it via
> `cargo install tree-sitter-cli` or `npm i -g tree-sitter-cli`.

---

## Debian / Ubuntu (apt)

```bash
sudo apt update
sudo apt install -y $(sed 's/#.*//' manifests/apt.txt)
nvim --headless -c "luafile manifests/provision.lua" -c "qa!"
```

Note Debian/Ubuntu name the fd binary `fdfind`; symlink it to `fd` for telescope
(`ln -s "$(which fdfind)" ~/.local/bin/fd`).

---

## What Mason installs (not in the OS manifests)

`provision.lua` drives these inside neovim:

- **LSP servers:** lua-language-server, rust-analyzer, gopls, basedpyright,
  bash-language-server, yaml-language-server, taplo, marksman,
  powershell-editor-services
- **Formatters/linters:** stylua, ruff, goimports, shfmt, prettier

rust-analyzer ships as a Mason-prebuilt binary, so a rust toolchain is **not**
strictly required — `rustup` is included only for editing/compiling Rust.
