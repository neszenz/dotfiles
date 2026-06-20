vim.pack.add({
    { src = 'https://github.com/tpope/vim-fugitive', version = 'v3.7' },
})

-- :Git command wrappers (fugitive is vimscript: no setup, just maps)
vim.keymap.set('n', '<leader>gg', ':tabe<CR>:Git<CR><C-w>j:q<CR>')
vim.keymap.set('n', '<leader>gb', ':Git blame<CR>')
