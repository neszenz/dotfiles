local config_support_range = vim.version.range("0.11")
assert(config_support_range:has(vim.version()), "config does not support version")

require("basics")

-- Install package manager lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- Load lazy.nvim and all packages
require("lazy").setup("plugins")
