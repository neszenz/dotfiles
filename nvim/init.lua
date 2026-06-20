local config_support_range = vim.version.range("0.12")
assert(config_support_range:has(vim.version()), "config does not support version")

require("neszenz.options")
require("neszenz.keymaps")

-- Plugins (explicit order; comment a line to disable)
require("neszenz.plugins.icons")
require("neszenz.plugins.oil")
require("neszenz.plugins.gitsigns")
require("neszenz.plugins.fugitive")
