vim.g.mapleader = ' '

vim.keymap.set('n', 'gt', ':tabnext<CR>', { desc = 'Next tab' })
vim.keymap.set('n', 'gT', ':tabprevious<CR>', { desc = 'Previous tab' })

vim.keymap.set('n', '<leader>gg', ':tabe<CR>:Git<CR>j:q<CR>', {})
vim.keymap.set('n', '<leader>gd', ':Git diff<CR>_', {})
vim.keymap.set('n', '<leader>gD', ':Git diff --staged<CR>_', {})

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', '<C-h>', '<C-w>h', {})
vim.keymap.set('n', '<C-j>', '<C-w>j', {})
vim.keymap.set('n', '<C-k>', '<C-w>k', {})
vim.keymap.set('n', '<C-l>', '<C-w>l', {})
vim.keymap.set('n', '', '<C-w>|', {})
vim.keymap.set('n', '<C-->', '<C-w>_', {})
vim.keymap.set('n', '<C-=>', '<C-w>=', {})

-- Keeping it in center
vim.keymap.set('n', '<C-d>', function ()
    local n = tonumber(vim.wo.scroll) - 1
    vim.cmd.normal(tostring(n).."jzz")
end)
vim.keymap.set('n', '<C-u>', function ()
    local n = tonumber(vim.wo.scroll) - 1
    vim.cmd.normal(tostring(n).."kzz")
end)
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

-- Quickfix / Diagnostic keymaps
vim.keymap.set('n', '[c', ':cprevious<CR>zz', { desc = ':cprevious' })
vim.keymap.set('n', ']c', ':cnext<CR>zz', { desc = ':cnext' })
vim.keymap.set('n', '[d', ':lua vim.diagnostic.goto_prev()<CR>zz', { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', ':lua vim.diagnostic.goto_next()<CR>zz', { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setqflist, { desc = 'Open diagnostics list' })

-- Random custom stuff and experimentation
vim.keymap.set('i', '<C-\\>', '\\', {})
vim.keymap.set('i', '\\#<', '#include <><esc>i', {})
vim.keymap.set('i', '\\#"', '#include ""<esc>i', {})

vim.keymap.set({'i'}, '\\k', '  i', {})
vim.keymap.set({'i'}, '\\j', '2cl', {})
vim.keymap.set({'i', 'n'}, '\\l', 'Ojok$', {})
vim.keymap.set({'i', 'n'}, '\\h', '0i<BS>A<Del>', {})

vim.keymap.set({'i'}, '<C-l>', '<Del>', {})

vim.keymap.set({'n','v','i'}, '<M-C-n>', '0', {})
vim.keymap.set({'n','v','i'}, '<M-C-m>', '1', {})
vim.keymap.set({'n','v','i'}, '<M-C-,>', '2', {})
vim.keymap.set({'n','v','i'}, '<M-C-.>', '3', {})
vim.keymap.set({'n','v','i'}, '<M-C-j>', '4', {})
vim.keymap.set({'n','v','i'}, '<M-C-k>', '5', {})
vim.keymap.set({'n','v','i'}, '<M-C-l>', '6', {})
vim.keymap.set({'n','v','i'}, '<M-C-u>', '7', {})
vim.keymap.set({'n','v','i'}, '<M-C-i>', '8', {})
vim.keymap.set({'n','v','i'}, '<M-C-o>', '9', {})

-- Read the the line specified by offset from file and execute it as command
local function exec_vaction(action_offset, mode)
    local cmd_file_path = '.vactions'
    local file = io.open(cmd_file_path, 'r')
    if file then
        local line_counter = 1
        while line_counter <= action_offset do
            local line = file:read()

            if line == nil then
                print("Error: .vactions out-of-bounds for action #"..action_offset)
                return
            end

            if line_counter == action_offset then
                local header = "vaction_"..action_offset.." >> "..line

                if mode == 0 then
                    print(header)
                    io.popen(line)
                elseif mode == 1 then
                    local cmd = "echo '"..header.."' && "..line
                    vim.cmd(":term "..cmd)
                    vim.cmd(":startinsert");
                elseif mode == 2 then
                    vim.cmd(":! echo -e '' && "..line)
                end
            end

            line_counter = line_counter + 1
        end
    else
        print("Error: .vactions not found")
    end
end

vim.keymap.set({'n','v','i'}, '<F1>', function() exec_vaction(1, 0) end)
vim.keymap.set({'n','v','i'}, '<F2>', function() exec_vaction(2, 0) end)
vim.keymap.set({'n','v','i'}, '<F3>', function() exec_vaction(3, 0) end)
vim.keymap.set({'n','v','i'}, '<F4>', function() exec_vaction(4, 0) end)
vim.keymap.set({'n','v','i'}, '<F5>', function() exec_vaction(5, 0) end)
vim.keymap.set({'n','v','i'}, '<F6>', function() exec_vaction(6, 0) end)
vim.keymap.set({'n','v','i'}, '<F7>', function() exec_vaction(7, 0) end)
vim.keymap.set({'n','v','i'}, '<F8>', function() exec_vaction(8, 0) end)
vim.keymap.set({'n','v','i'}, '<F9>', function() exec_vaction(9, 0) end)
vim.keymap.set({'n','v','i'}, '<F10>', function() exec_vaction(10, 0) end)
vim.keymap.set({'n','v','i'}, '<F11>', function() exec_vaction(11, 0) end)
vim.keymap.set({'n','v','i'}, '<F12>', function() exec_vaction(12, 0) end)

vim.keymap.set({'n','v','i'}, '<F13>', function() exec_vaction(1, 1) end)
vim.keymap.set({'n','v','i'}, '<F14>', function() exec_vaction(2, 1) end)
vim.keymap.set({'n','v','i'}, '<F15>', function() exec_vaction(3, 1) end)
vim.keymap.set({'n','v','i'}, '<F16>', function() exec_vaction(4, 1) end)
vim.keymap.set({'n','v','i'}, '<F17>', function() exec_vaction(5, 1) end)
vim.keymap.set({'n','v','i'}, '<F18>', function() exec_vaction(6, 1) end)
vim.keymap.set({'n','v','i'}, '<F19>', function() exec_vaction(7, 1) end)
vim.keymap.set({'n','v','i'}, '<F20>', function() exec_vaction(8, 1) end)
vim.keymap.set({'n','v','i'}, '<F21>', function() exec_vaction(9, 1) end)
vim.keymap.set({'n','v','i'}, '<F22>', function() exec_vaction(10, 1) end)
vim.keymap.set({'n','v','i'}, '<F23>', function() exec_vaction(11, 1) end)
vim.keymap.set({'n','v','i'}, '<F24>', function() exec_vaction(12, 1) end)

vim.keymap.set({'n','v','i'}, '<S-F1>', function() exec_vaction(1, 1) end)
vim.keymap.set({'n','v','i'}, '<S-F2>', function() exec_vaction(2, 1) end)
vim.keymap.set({'n','v','i'}, '<S-F3>', function() exec_vaction(3, 1) end)
vim.keymap.set({'n','v','i'}, '<S-F4>', function() exec_vaction(4, 1) end)
vim.keymap.set({'n','v','i'}, '<S-F5>', function() exec_vaction(5, 1) end)
vim.keymap.set({'n','v','i'}, '<S-F6>', function() exec_vaction(6, 1) end)
vim.keymap.set({'n','v','i'}, '<S-F7>', function() exec_vaction(7, 1) end)
vim.keymap.set({'n','v','i'}, '<S-F8>', function() exec_vaction(8, 1) end)
vim.keymap.set({'n','v','i'}, '<S-F9>', function() exec_vaction(9, 1) end)
vim.keymap.set({'n','v','i'}, '<S-F10>', function() exec_vaction(10, 1) end)
vim.keymap.set({'n','v','i'}, '<S-F11>', function() exec_vaction(11, 1) end)
vim.keymap.set({'n','v','i'}, '<S-F12>', function() exec_vaction(12, 1) end)

local function toggleVFile(vfile_basename)
    local current_buffer = vim.api.nvim_get_current_buf()
    local current_buffer_basename = vim.fs.basename(vim.api.nvim_buf_get_name(current_buffer))

    if current_buffer_basename == vfile_basename then
        print('Update and leave '..vfile_basename)
        vim.cmd(':update | :bwipeout')
    else
        print('Enter '..vfile_basename..' for '..vim.fn.getcwd())
        vim.cmd(':drop '..vfile_basename)
    end
end

vim.keymap.set('n', '<leader>va', function() toggleVFile('.vactions') end, { desc = 'Toggle vactions' })
vim.keymap.set('n', '<leader>vn', function() toggleVFile('.vnotes.md') end, { desc = 'Toggle vnotes' })
