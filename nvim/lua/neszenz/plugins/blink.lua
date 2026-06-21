-- Completion. Mostly blink defaults for now; cmp-like tweaks deferred (see README
-- roadmap): selection.auto_insert=false, documentation.auto_show=true, trimmed sources.
vim.pack.add({
    { src = 'https://github.com/Saghen/blink.cmp', version = 'v1.10.2' },
    'https://github.com/rafamadriz/friendly-snippets',
})

require('blink.cmp').setup({
    keymap = {
        preset = 'default',
        ['<C-space>'] = {},  -- disabled (manual trigger is <C-x><C-m>, set below)
    },
    completion = {
        -- never pop up while typing; only open via <C-x><C-m>
        trigger = { show_on_keyword = false, show_on_trigger_character = false },
        documentation = { auto_show = true },  -- show docs for the selected item
    },
    sources = {
        default = { 'lsp', 'path', 'snippets' },  -- 'buffer' dropped (≈ native <C-x><C-n>)
    },
})

-- blink handles its keys internally and doesn't support a 2-key chord in its
-- keymap table, so bind the manual trigger directly (matches old cmp.complete()).
vim.keymap.set('i', '<C-x><C-m>', function() require('blink.cmp').show() end, { desc = 'Trigger completion' })
