return {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        local oil = require('oil')

        oil.setup {
            columns = { 'icon' },
            keymaps = {
                ['<C-s>'] = false,
                ['<C-h>'] = false,
                ['<C-c>'] = false,
                ['<C-p>'] = function () oil.open_preview{split="botright"} end,
                ['q'] = 'actions.close',
            },
            view_options = {
                show_hidden = false,
            },
            float = {
                padding = 8,
            },
        }

        vim.keymap.set('n', '-', oil.open, { desc = 'Oil' })
        vim.keymap.set('n', '<space>-', require('oil').toggle_float)
    end
}
