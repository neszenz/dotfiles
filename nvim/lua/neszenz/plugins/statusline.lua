-- Minimal statusline from the mini ecosystem; reuses mini.icons (see icons.lua).
vim.pack.add({
    { src = 'https://github.com/echasnovski/mini.statusline', version = 'v0.18.0' },
})

require('mini.statusline').setup()
