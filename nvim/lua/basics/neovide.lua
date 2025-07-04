vim.g.neovide_transparency = 0.6
vim.g.neovide_fullscreen = true
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_refresh_rate = 120
-- vim.g.neovide_cursor_vfx_mode = "sonicboom"

vim.keymap.set('n', '<C-Up>', function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
    vim.cmd.normal('hl')
end, {})

vim.keymap.set('n', '<C-Down>', function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
    vim.cmd.normal('hl')
end, {})
