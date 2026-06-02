-- Headless provisioning step for gronk.nvim.
-- Run AFTER the config is in place and scoop deps are installed:
--   nvim --headless -c "luafile manifests/provision.lua" -c "qa!"
-- (For the nvc/side-by-side target, NVIM_APPNAME + XDG_CONFIG_HOME must be set
--  in the environment first so this loads the right config.)
--
-- It is idempotent: re-running only fills in whatever is missing.
--   1. Lazy! sync         — install/update all plugins (blocks; the ! waits)
--   2. treesitter parsers — compile the configured set (needs gcc + tree-sitter CLI)
--   3. Mason tools        — LSP servers + formatters, waiting for completion

local function log(msg)
  io.stdout:write('[provision] ' .. msg .. '\n')
end

-- 1. Plugins ------------------------------------------------------------------
log 'syncing plugins (Lazy! sync) ...'
pcall(vim.cmd, 'Lazy! sync')

-- 2. Treesitter parsers -------------------------------------------------------
-- Keep this list in sync with lua/plugins/nvim-treesitter.lua.
local parsers = {
  'bash', 'diff', 'gitcommit', 'gitignore', 'go', 'gomod', 'html', 'lua',
  'luadoc', 'markdown', 'markdown_inline', 'powershell', 'python', 'query',
  'rust', 'toml', 'vim', 'vimdoc', 'yaml',
}
local ok_ts, ts = pcall(require, 'nvim-treesitter')
if ok_ts and ts.install then
  log('installing ' .. #parsers .. ' treesitter parsers (this can take a while) ...')
  local ok_wait = pcall(function()
    ts.install(parsers):wait(600000)
  end)
  log('treesitter parsers: ' .. (ok_wait and 'done' or 'finished with errors (check :checkhealth)'))
else
  log 'WARN nvim-treesitter not available or wrong branch (need branch=main)'
end

-- 3. Mason tools --------------------------------------------------------------
pcall(function()
  require('lazy').load { plugins = { 'mason.nvim', 'mason-tool-installer.nvim' } }
end)
if pcall(require, 'mason') then
  log 'installing Mason LSP servers + formatters ...'
  local done = false
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MasonToolsUpdateCompleted',
    callback = function() done = true end,
  })
  pcall(vim.cmd, 'MasonToolsInstall')
  vim.wait(600000, function() return done end, 1000)
  log('Mason: ' .. (done and 'done' or 'timed out (re-run provision.lua)'))
else
  log 'WARN mason not available'
end

log 'provisioning complete.'
