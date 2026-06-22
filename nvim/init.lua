local config_support_range = vim.version.range("0.12")
if config_support_range == nil then
    error("could not parse config version range")
end
assert(config_support_range:has(vim.version()), "config does not support version")

require("neszenz.options")
require("neszenz.keymaps")

-- Plugins (explicit order; comment a line to disable)
require("neszenz.plugins.icons")
require("neszenz.plugins.oil")
require("neszenz.plugins.gitsigns")
require("neszenz.plugins.fugitive")
require("neszenz.plugins.treesitter")
require("neszenz.plugins.treesitter-context")
require("neszenz.plugins.lsp")
require("neszenz.plugins.blink")
require("neszenz.plugins.aerial")
require("neszenz.plugins.tmux")
require("neszenz.plugins.telescope")
require("neszenz.plugins.colorscheme")
