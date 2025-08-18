---[[ configure LSP servers here ]]---

-- vim.lsp.config('rust-analyzer', {}) -- adding config since otherwise checkhealth complains
-- vim.lsp.enable 'rust-analyzer' -- rust LSP
--
-- vim.lsp.config('ruff', {})
-- vim.lsp.enable 'ruff' -- Python LSP
--
-- vim.lsp.config('biome', {})
-- vim.lsp.enable 'biome' -- web stuff: HTML, CSS, JS, etc
--
-- vim.lsp.config('clangd', {})
-- vim.lsp.enable 'clangd' -- cpp, clangd needs external configuration using compile_commands.json NOTE

vim.lsp.enable 'rust-analyzer'
-- vim.lsp.config('rust-analyzer')
-- if rust-analyzer refuses to cooperate, make sure rust-analyzer is properly installed:
-- `rustup component add rust-analyzer`

vim.lsp.enable 'basedpyright'
-- vim.lsp.enable 'pyright'

vim.lsp.enable 'lua_ls'
