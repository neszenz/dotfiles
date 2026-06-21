-- Shows the enclosing function/class at the top of the window.
-- master-only repo (no semver releases); lockfile pins the rev.
vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context', version = 'master' },
})

require('treesitter-context').setup()  -- defaults match the old config
