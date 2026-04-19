-- Set leaders before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load options first
require("config.options")

-- Load plugins via vim.pack (nvim 0.12 built-in package manager)
require("config.plugins")

-- Load keymaps and autocmds after plugins are available
require("config.keymaps")
require("config.autocmds")
