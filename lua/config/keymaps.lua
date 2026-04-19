local keymap = vim.keymap.set

-- CTRL+V Copy Paste (insert mode)
keymap("i", "<C-v>", "<C-r>+", { noremap = true, silent = true })

-- CTRL+V Copy Paste for Terminal
function _G.paste_from_clipboard_in_terminal()
  local paste_command = vim.fn.system("pbpaste")
  vim.api.nvim_put({ paste_command }, "", false, true)
end
keymap("t", "<C-v>", "<Cmd>lua paste_from_clipboard_in_terminal()<CR>", { noremap = true, silent = true })

-- Stop Shift+Space from clearing Terminal
keymap("t", "<S-Space>", "<nop>", { noremap = true, silent = true })

-- Remap C-n to C-v (visual block)
keymap("n", "<C-n>", "<C-v>", { noremap = true, silent = true })

-- Copy current filename
keymap("n", "<leader>yf", ':let @+=expand("%:p")<CR>', { desc = "Copy current filename" })

-- Select entire buffer
keymap("o", "ag", ":<C-u>normal! ggVG<CR>", { desc = "Select entire buffer" })
keymap("x", "ag", ":<C-u>normal! ggVG<CR>", { desc = "Select entire buffer" })

-- Toggle diagnostics
keymap("n", "]o", "<cmd>DiagnosticsToggle<cr>", { desc = "Toggle Diagnostics" })

-- Jump to next/prev error
keymap("n", "]e", function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Next Error" })

keymap("n", "[e", function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Prev Error" })

-- Jump to next/prev diagnostic (any severity)
keymap("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next Diagnostic" })

keymap("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev Diagnostic" })

-- Display current diagnostic in a floating window
keymap("n", "<leader>cd", function()
  vim.diagnostic.open_float({ focus = true })
end, { desc = "Line Diagnostics" })

-------------------------------------------------------------------------------
-- Bufferline
-------------------------------------------------------------------------------
keymap("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
keymap("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
keymap("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
keymap("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
keymap("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete Other Buffers" })
keymap("n", "<leader>bd", function() require("mini.bufremove").delete(0, false) end, { desc = "Delete Buffer" })
keymap("n", "<leader>bD", function() require("mini.bufremove").delete(0, true) end, { desc = "Delete Buffer (Force)" })

-------------------------------------------------------------------------------
-- Neo-tree
-------------------------------------------------------------------------------
keymap("n", "<leader>e", function()
  require("config.plugins").ensure_neo_tree()
  vim.cmd("Neotree toggle")
end, { desc = "Toggle NeoTree" })

-------------------------------------------------------------------------------
-- Telescope
-------------------------------------------------------------------------------
keymap("n", "<leader><space>", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
keymap("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "Git Files" })
keymap("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
keymap("n", "<leader>sw", "<cmd>Telescope grep_string<cr>", { desc = "Grep Word" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
keymap("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Commands" })
keymap("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git Commits" })
keymap("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git Branches" })
keymap("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git Status" })
keymap("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Go to Definition" })
keymap("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "References" })
keymap("n", "gi", "<cmd>Telescope lsp_implementations<cr>", { desc = "Implementations" })
keymap("n", "<leader>D", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Type Definition" })
keymap("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document Symbols" })
keymap("n", "<leader>ws", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Workspace Symbols" })

-------------------------------------------------------------------------------
-- Conform (formatting)
-------------------------------------------------------------------------------
keymap({ "n", "v" }, "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-------------------------------------------------------------------------------
-- DAP (debugging)
-------------------------------------------------------------------------------
keymap("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
keymap("n", "<leader>dc", function() require("dap").continue() end, { desc = "Continue" })
keymap("n", "<leader>ds", function() require("dap").step_over() end, { desc = "Step Over" })
keymap("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step Into" })
keymap("n", "<leader>do", function() require("dap").step_out() end, { desc = "Step Out" })
keymap("n", "<leader>dr", function() require("dap").repl.open() end, { desc = "Open REPL" })
keymap("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle DAP UI" })

-------------------------------------------------------------------------------
-- LazyGit
-------------------------------------------------------------------------------
keymap("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

-------------------------------------------------------------------------------
-- Snacks
-------------------------------------------------------------------------------
keymap({ "n", "x" }, "<leader>go", function() Snacks.gitbrowse() end, { desc = "Git Open in Browser" })
keymap({ "n", "x" }, "<leader>gm", function() Snacks.gitbrowse({ branch = "main" }) end, { desc = "Git Open main in Browser" })

-------------------------------------------------------------------------------
-- Which-key
-------------------------------------------------------------------------------
keymap("n", "<leader>?", function() require("which-key").show({ global = false }) end, { desc = "Buffer Local Keymaps" })

-------------------------------------------------------------------------------
-- Markdown Preview
-------------------------------------------------------------------------------
keymap("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown Preview" })

-------------------------------------------------------------------------------
-- Opencode
-------------------------------------------------------------------------------
keymap("n", "<leader>ot", function() require("opencode").toggle() end, { desc = "Toggle embedded" })
keymap("n", "<leader>oa", function() require("opencode").ask("@cursor: ", { submit = true }) end, { desc = "Ask about this" })
keymap("v", "<leader>oa", function() require("opencode").ask("@selection: ", { submit = true }) end, { desc = "Ask about selection" })
keymap("n", "<leader>o+", function() require("opencode").prompt("@buffer", { append = true }) end, { desc = "Add buffer to prompt" })
keymap("v", "<leader>o+", function() require("opencode").prompt("@selection", { append = true }) end, { desc = "Add selection to prompt" })
keymap("n", "<leader>oe", function() require("opencode").prompt("Explain @cursor and its context", { submit = true }) end, { desc = "Explain this code" })
keymap("n", "<leader>on", function() require("opencode").command("session_new") end, { desc = "New session" })
keymap("n", "<S-C-u>", function() require("opencode").command("messages_half_page_up") end, { desc = "Messages half page up" })
keymap("n", "<S-C-d>", function() require("opencode").command("messages_half_page_down") end, { desc = "Messages half page down" })
keymap({ "n", "v" }, "<leader>os", function() require("opencode").select() end, { desc = "Select prompt" })
