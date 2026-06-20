-- Shared icon provider (oil now; statusline etc. later).
-- Leaner than nvim-web-devicons; mocks its API so any plugin expecting it works.
vim.pack.add({
    { src = 'https://github.com/echasnovski/mini.icons', version = 'v0.17.0' },
})

require('mini.icons').setup()
require('mini.icons').mock_nvim_web_devicons()
