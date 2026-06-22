vim.pack.add({
    'https://github.com/navarasu/onedark.nvim',
})

local palette = require('onedark.palette').cool
local hl_overrides ={
    TelescopeResultsBorder = {
        fg = palette.bg3
    },
    TelescopePromptBorder = {
        fg = palette.bg3
    },
    TelescopePreviewBorder = {
        fg = palette.bg3
    }
}

require('onedark').setup {
    style = 'darker',
    transparent = false,
    highlights = hl_overrides
}

require('onedark').load()
