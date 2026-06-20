vim.pack.add({
    { src = 'https://github.com/lewis6991/gitsigns.nvim', version = 'v2.1.0' },
})

require('gitsigns').setup {
    signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
        local gs = require('gitsigns')
        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map('n', '<leader>gh', gs.preview_hunk, 'Preview git hunk')

        -- ]h / [h jump hunks ([c / ]c are taken by quickfix);
        -- fall back to the native diff motion when inside a diff
        map({ 'n', 'v' }, ']h', function()
            if vim.wo.diff then vim.cmd.normal({ ']c', bang = true }) else gs.nav_hunk('next') end
        end, 'Next hunk')
        map({ 'n', 'v' }, '[h', function()
            if vim.wo.diff then vim.cmd.normal({ '[c', bang = true }) else gs.nav_hunk('prev') end
        end, 'Previous hunk')
    end,
}
