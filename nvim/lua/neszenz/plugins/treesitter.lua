-- nvim-treesitter `main`: parser installer + queries only.
-- Highlighting/folding are native (vim.treesitter); modules are gone.
-- No aligned semver tags on `main`, so track the branch; lockfile pins the rev.
vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
})

require('nvim-treesitter').install({
    'bash', 'c', 'cpp', 'go', 'rust', 'zig',
    'lua', 'markdown', 'markdown_inline',
    'json', 'yaml', 'toml',
})

-- Recompile parsers when the plugin itself updates (replaces build = ':TSUpdate')
vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' then
            if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
            vim.cmd('TSUpdate')
        end
    end,
})

-- Start highlighting for any buffer whose language has a parser (bundled or installed)
vim.api.nvim_create_autocmd('FileType', {
    callback = function() pcall(vim.treesitter.start) end,
})

-- Native treesitter folding; folds open by default (indentation stays built-in)
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevelstart = 99
