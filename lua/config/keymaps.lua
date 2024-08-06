-- keymaps are automatically loaded on the VeryLazy event
-- default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- add any additional keymaps here

-- CTRL+V Copy Paste
vim.api.nvim_set_keymap("i", "<C-v>", "<C-r>+", { noremap = true, silent = true })

-- CTRL+V Copy Paste for Terminal
function _G.paste_from_clipboard_in_terminal()
  local system_clipboard_command = "pbpaste" -- Adjust based on your system, e.g., use 'xclip -o' or 'xsel -b' for Linux
  local paste_command = vim.fn.system(system_clipboard_command)
  vim.api.nvim_put({ paste_command }, "", false, true)
end

vim.api.nvim_set_keymap(
  "t",
  "<C-v>",
  "<Cmd>lua paste_from_clipboard_in_terminal()<CR>",
  { noremap = true, silent = true }
)

-- Stop Shift+Space from clearing Terminal
vim.api.nvim_set_keymap("t", "<S-Space>", "<nop>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>xr", ":LspRestart<CR>", { noremap = true, silent = true })

-- Remove the default keymap for <C-n> and map it to <C-v>
vim.api.nvim_set_keymap("n", "<C-n>", "<C-v>", { noremap = true, silent = true })

-- Copy the current file path to the clipboard
vim.api.nvim_set_keymap("n", "<leader>yf", ':let @+=expand("%:p")<CR>', { noremap = true, silent = true })
