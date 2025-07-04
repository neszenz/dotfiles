return {
    'ThePrimeagen/vim-be-good',

    {
        'mbbill/undotree',
        config = function()
            vim.keymap.set({'n'}, '<leader>u', ':UndotreeToggle<CR><C-w>h', { silent = true, desc = 'UndotreeToggle' })
        end
    },

    -- git integration
    'tpope/vim-fugitive',

    -- gc and gb to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },

    -- Add indentation guides even on blank lines
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        opts = {
            indent = {
                char = '┊',
                tab_char = '║',
            },
            scope = {
                enabled = false,
            },
        }
    },

    {
        'sindrets/diffview.nvim'
    },

    -- Adds git related signs to the gutter, as well as utilities for managing changes
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>gh', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk under cursor' })
                vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { desc = 'Git blame' })

                -- don't override the built-in and fugitive keymaps
                local gs = package.loaded.gitsigns
                vim.keymap.set({'n', 'v'}, ']h', function()
                    if vim.wo.diff then return ']h' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, {expr=true, buffer = bufnr, desc = "Jump to next hunk"})
                vim.keymap.set({'n', 'v'}, '[h', function()
                    if vim.wo.diff then return '[h' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, {expr=true, buffer = bufnr, desc = "Jump to previous hunk"})
            end,
        },
    },

    {
        'anuvyklack/pretty-fold.nvim',
        opts = {
            sections = {
                left = {
                    'content',
                },
                right = {
                    ' ', 'number_of_folded_lines', ': ', 'percentage', ' ',
                    function(config) return config.fill_char:rep(3) end
                }
            },

            fill_char = '·',

            remove_fold_markers = true,

            -- Keep the indentation of the content of the fold string.
            keep_indentation = true,

            -- Possible values:
            -- "delete" : Delete all comment signs from the fold string.
            -- "spaces" : Replace all comment signs with equal number of spaces.
            -- false    : Do nothing with comment signs.
            process_comment_signs = 'spaces',

            -- Comment signs additional to the value of `&commentstring` option.
            comment_signs = {},

            -- List of patterns that will be removed from content foldtext section.
            stop_words = {
                '@brief%s*', -- (for C++) Remove '@brief' and all spaces after.
            },

            add_close_pattern = true, -- true, 'last_line' or false

            matchup_patterns = {
                {  '{', '}' },
                { '%(', ')' }, -- % to escape lua pattern char
                { '%[', ']' }, -- % to escape lua pattern char
            },

            ft_ignore = { 'neorg' }
        }
    },
}
