vim.pack.add({
    { src = 'https://github.com/stevearc/oil.nvim', version = 'v2.16.0' },
})

local oil = require('oil')

oil.setup {
    default_file_explorer = true,  -- take over directory buffers (nvim ., :e dir/)
    columns = { 'icon' },          -- icons via mini.icons (see plugin/icons.lua)
    keymaps = {
        ['<C-h>'] = false,  -- keep global window-left nav inside oil
        ['<C-l>'] = false,  -- keep global window-right nav (drops oil refresh)
        ['<C-s>'] = false,
        ['<C-c>'] = false,
        ['<C-p>'] = function() oil.open_preview({ split = 'botright' }) end,
        ['q'] = 'actions.close',
    },
    float = { padding = 8 },
}

vim.keymap.set('n', '-', oil.open, { desc = 'Oil' })
vim.keymap.set('n', '<leader>-', oil.toggle_float, { desc = 'Oil (float)' })
