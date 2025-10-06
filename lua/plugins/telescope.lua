return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    local ignore_patterns = {
      ".git/",
      "**.venv",
      "**__pycache__",
      "**.mypy_cache",
      "**.pytest_cache",
    }

    local function build_rg_globs(patterns)
      local args = {}
      for _, pattern in ipairs(patterns) do
        table.insert(args, "--glob")
        table.insert(args, "!" .. pattern)
      end
      return args
    end

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<esc>"] = actions.close,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<C-u>"] = actions.preview_scrolling_up,
          },
          n = {
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          },
        },
        file_ignore_patterns = { "node_modules", ".git/", ".pytest_cache" },
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
          find_command = vim.list_extend(
            { "rg", "--files", "--hidden", "--no-ignore-vcs" },
            build_rg_globs(ignore_patterns)
          ),
        },
        live_grep = {
          additional_args = function()
            return vim.list_extend(
              { "--hidden", "--no-ignore-vcs" },
              build_rg_globs(ignore_patterns)
            )
          end,
        },
      },
    })

    -- Load extensions
    telescope.load_extension("fzf")
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
