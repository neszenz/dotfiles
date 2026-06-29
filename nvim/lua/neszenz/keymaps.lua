vim.g.mapleader = ' '

-- Tabs
vim.keymap.set('n', 'gt', ':tabnext<CR>')
vim.keymap.set('n', 'gT', ':tabprevious<CR>')

-- Treat j/k as display lines, but only without a count (so 5j still works)
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Window navigation (note: tmux.nvim will later extend these across tmux panes)
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Arrow keys to scroll window instead of moving cursor
vim.keymap.set('n', '<Up>', '3<C-y>')
vim.keymap.set('n', '<Down>', '3<C-e>')
vim.keymap.set('n', '<Left>', '10zh')
vim.keymap.set('n', '<Right>', '10zl')

-- Half-page scroll + search, keeping the cursor line centered
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

-- Quickfix / diagnostics (all add 'zz' to re-center after jumping)
vim.keymap.set('n', '[c', ':cprevious<CR>zz')
vim.keymap.set('n', ']c', ':cnext<CR>zz')
vim.keymap.set('n', '[d', ':lua vim.diagnostic.goto_prev()<CR>zz')
vim.keymap.set('n', ']d', ':lua vim.diagnostic.goto_next()<CR>zz')
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setqflist)

-- Random custom insert mode helpers
vim.keymap.set('i', '<C-\\>', '\\')
vim.keymap.set('i', '\\#<', '#include <><esc>i')
vim.keymap.set('i', '\\#"', '#include ""<esc>i')
vim.keymap.set({'i'}, '\\k', '  <C-[>i')
vim.keymap.set({'i'}, '\\j', '<C-[>2cl')
vim.keymap.set({'i', 'n'}, '\\l', '<C-[>O<C-[>jo<C-[>k$')
vim.keymap.set({'i', 'n'}, '\\h', '<C-[>0i<BS><C-[>A<Del><C-[>')
vim.keymap.set({ 'i' }, '<C-l>', '<Del>')

-------------------------------------------------------------------------------
-- "vactions": run line N of a project-local .vactions file as a command.
--   mode 0 = io.popen (silent), 1 = :term (interactive), 2 = :! (shell)
-------------------------------------------------------------------------------
local function exec_vaction(action_offset, mode)
    local cmd_file_path = '.vactions'
    local file = io.open(cmd_file_path, 'r')
    if file then
        local line_counter = 1
        while line_counter <= action_offset do
            local line = file:read()

            if line == nil then
                print("Error: .vactions out-of-bounds for action #" .. action_offset)
                return
            end

            if line_counter == action_offset then
                local header = "vaction_" .. action_offset .. " >> " .. line

                if mode == 0 then
                    print(header)
                    io.popen(line)
                elseif mode == 1 then
                    local cmd = "echo " .. vim.fn.shellescape(header) .. " && " .. line
                    vim.cmd(":term " .. cmd)
                    vim.cmd(":startinsert");
                elseif mode == 2 then
                    vim.cmd(":! echo -e '' && " .. line)
                end
            end

            line_counter = line_counter + 1
        end
    else
        print("Error: .vactions not found")
    end
end

-- F1-F12: run actions silently; F13-F24 / S-F1-F12: run in a terminal
for i = 1, 12 do
    vim.keymap.set({ 'n', 'v', 'i' }, '<F' .. i .. '>', function() exec_vaction(i, 0) end)
    vim.keymap.set({ 'n', 'v', 'i' }, '<F' .. (i + 12) .. '>', function() exec_vaction(i, 1) end)
    vim.keymap.set({ 'n', 'v', 'i' }, '<S-F' .. i .. '>', function() exec_vaction(i, 1) end)
end

-- Toggle a project-local scratch file (open it, or save+close if already in it)
local function toggleVFile(vfile_basename)
    local current_buffer = vim.api.nvim_get_current_buf()
    local current_buffer_basename = vim.fs.basename(vim.api.nvim_buf_get_name(current_buffer))

    if current_buffer_basename == vfile_basename then
        print('Update and leave ' .. vfile_basename)
        vim.cmd(':update | :bwipeout')
    else
        print('Enter ' .. vfile_basename .. ' for ' .. vim.fn.getcwd())
        vim.cmd(':drop ' .. vfile_basename)
    end
end

vim.keymap.set('n', '<leader>va', function() toggleVFile('.vactions') end, { desc = 'Toggle .vactions' })
vim.keymap.set('n', '<leader>vn', function() toggleVFile('.vnotes.md') end, { desc = 'Toggle .vnotes' })
