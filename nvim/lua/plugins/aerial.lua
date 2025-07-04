return {
    'stevearc/aerial.nvim',
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        -- optionally use on_attach to set keymaps when aerial has attached to a buffer
        on_attach = function(bufnr)
            vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle left<CR>', { buffer = bufnr})
        end,
        keymaps = {
            ["?"] = false,
            ["<CR>"] = "actions.jump",
            ["p"] = "actions.scroll",
            ["<S-j>"] = "actions.down_and_scroll",
            ["<S-k>"] = "actions.up_and_scroll",
            ["{"] = "actions.prev",
            ["}"] = "actions.next",
            ["q"] = "actions.close",
            ["za"] = "actions.tree_toggle",
            ["zA"] = "actions.tree_toggle_recursive",
            ["l"] = "actions.tree_open",
            ["zo"] = "actions.tree_open",
            ["L"] = "actions.tree_open_recursive",
            ["zO"] = "actions.tree_open_recursive",
            ["h"] = "actions.tree_close",
            ["zc"] = "actions.tree_close",
            ["H"] = "actions.tree_close_recursive",
            ["zC"] = "actions.tree_close_recursive",
            ["zr"] = "actions.tree_increase_fold_level",
            ["zR"] = "actions.tree_open_all",
            ["zm"] = "actions.tree_decrease_fold_level",
            ["zM"] = "actions.tree_close_all",
            ["zx"] = "actions.tree_sync_folds",
            ["zX"] = "actions.tree_sync_folds",
        },
        highlight_on_hover = true,
        close_on_select = true,
        nav = {
            autojump = true,
            preview = false,
            keymaps = {
                ["<CR>"] = "actions.jump",
                ["h"] = "actions.left",
                ["l"] = "actions.right",
                ["q"] = "actions.close",
            },
        },
    }
}
