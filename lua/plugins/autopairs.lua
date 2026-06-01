-- https://github.com/windwp/nvim-autopairs
return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    require('nvim-autopairs').setup {}
    -- blink.cmp integration: auto_brackets is disabled in blink config,
    -- so autopairs has full control over bracket insertion
  end,
}
