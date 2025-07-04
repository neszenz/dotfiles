return {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require('telescope.builtin')

        vim.keymap.set('n', '<leader>;', builtin.command_history, { desc = 'Telescope command_history' })
        vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = 'Telescope oldfiles' })
        vim.keymap.set('n', '<leader>/', function()
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end, { desc = 'Telescope current_buffer_fuzzy_find' })

        vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Telescope git_files' })
        vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = 'Telescope git_commits' })

        vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = 'Telescope buffers' })
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Telescope find_files' })
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Telescope help_tags' })
        vim.keymap.set('n', '<leader>sw', function() builtin.grep_string({ search = vim.fn.input('Filter: ') }); end, { desc = 'Telescope grep_string (filtered)' })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Telescope live_grep' })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Telescope diagnostics' })
        vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Telescope resume' })

        -- Enable telescope fzf native if installed
        pcall(require('telescope').load_extension, 'fzf')
    end
}
