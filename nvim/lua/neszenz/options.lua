-- UI / display
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.colorcolumn = '81,121'
vim.opt.termguicolors = true
vim.opt.showmode = true
vim.opt.wrap = false             -- toggle on temporarily with :set wrap
vim.opt.linebreak = true         -- when wrapped, break at word boundaries
vim.opt.breakindent = true       -- when wrapped, keep the indent
vim.opt.smoothscroll = true      -- when wrapped, scroll by screen line not buffer line
vim.opt.winborder = 'rounded'

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Files / persistence
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.modeline = false

-- Behavior
vim.opt.mouse = 'nv'
vim.opt.updatetime = 250
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.completeopt = 'menuone'

-- Comment/formatting flags applied to every filetype:
--   c=auto-wrap comments, r=continue comment on <CR>, q=allow gq, j=smart join.
--   Notably omits 'o' (no comment continuation on o/O) and 't' (no autowrap of code).
vim.cmd [[autocmd FileType * setlocal formatoptions=crqj]]

-- Briefly highlight yanked text
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.hl.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- Auto-save/restore cursor per file via view files. 'folds' is excluded on
-- purpose so saved views can't override treesitter's foldmethod/foldexpr.
vim.opt.viewoptions = 'cursor'

-- Only for real, named file buffers (skip terminals, help, oil, git buffers, ...)
local view_ignore_ft = { gitcommit = true, gitrebase = true, oil = true }
local function view_eligible(buf)
    return vim.bo[buf].buftype == ''
        and not view_ignore_ft[vim.bo[buf].filetype]
        and vim.api.nvim_buf_get_name(buf) ~= ''
end

local view_group = vim.api.nvim_create_augroup('RememberView', { clear = true })
vim.api.nvim_create_autocmd('BufWinEnter', {
    group = view_group,
    callback = function(ev) if view_eligible(ev.buf) then vim.cmd('silent! loadview') end end,
})
vim.api.nvim_create_autocmd('BufWinLeave', {
    group = view_group,
    callback = function(ev) if view_eligible(ev.buf) then vim.cmd('silent! mkview') end end,
})

