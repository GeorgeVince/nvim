-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.api.nvim_set_keymap("i", "<C-v>", "<C-r>+", { noremap = true, silent = true })
