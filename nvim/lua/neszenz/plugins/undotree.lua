-- Visualize the undo history (relies on undofile, set in options.lua).
vim.pack.add({
    { src = 'https://github.com/mbbill/undotree', version = 'rel_6.1' },
})

-- Toggle the tree and jump into its window
vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR><C-w>h', { silent = true })
