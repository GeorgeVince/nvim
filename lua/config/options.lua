-- Disable netrw (Neo-tree replaces it)
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

-- General options
vim.opt.clipboard = "unnamedplus"
vim.opt.hidden = true
vim.opt.number = true
-- cmdheight=0 hides the command line entirely, but any vim.notify/echo/print
-- that fires before noice.nvim loads will trigger "Press any key to continue".
-- Set to 1 (default) for stability, noice handles the rest.
vim.opt.cmdheight = 1
vim.opt.undofile = true
vim.opt.mouse = "a"
vim.opt.swapfile = false
vim.opt.autoread = true
