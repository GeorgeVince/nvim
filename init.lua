-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

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
