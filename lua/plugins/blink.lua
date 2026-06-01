return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '1.*',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'super-tab': tab to accept, matches VSCode muscle memory
    keymap = { preset = 'super-tab' },

    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = {
      -- disable blink's built-in bracket insertion — nvim-autopairs handles it
      accept = { auto_brackets = { enabled = false } },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    },

    sources = {
      default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
      },
    },

    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
