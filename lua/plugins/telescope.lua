return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x', 
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    
    telescope.setup({
      defaults = {
        mappings = {
         i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<esc>"] = actions.close,
          },
        },
        file_ignore_patterns = { "node_modules", ".git/" },
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            preview_width = 0.6,
          },
        },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
          previewer = false,
	  find_command = { "rg", "--files", "--hidden", "--no-ignore-vcs", "--glob", "!.git/", "--glob", "!**.venv", "--glob", "!**__pycache__" },
        },
        live_grep = {
          additional_args = function()
            return { "--hidden", "--no-ignore-vcs", "--glob", "!.git/", "--glob", "!**.venv", "--glob", "!**__pycache__" }
          end,
        },
      },
    })
    
    -- Load extensions
    telescope.load_extension('fzf')
  end,
  keys = {
    { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
    
    { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Grep Word" },
    
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
    { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
    
    { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
    { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
    { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
    
    { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Go to Definition" },
    { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
    { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
    { "<leader>D", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Type Definition" },
    { "<leader>ds", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
    { "<leader>ws", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
  },
  cmd = "Telescope",
}
