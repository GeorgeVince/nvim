local M = {}

-- Helper for GitHub URLs
local gh = function(x) return "https://github.com/" .. x end

-------------------------------------------------------------------------------
-- Build hooks (run after install/update)
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= "install" and kind ~= "update" then
      return
    end

    -- Treesitter: update parsers
    if name == "nvim-treesitter" then
      vim.cmd("TSUpdate")
    end

    -- Telescope fzf-native: compile
    if name == "telescope-fzf-native.nvim" then
      vim.system({ "make" }, { cwd = ev.data.path }):wait()
    end

    -- Markdown preview: install
    if name == "markdown-preview.nvim" then
      vim.fn["mkdp#util#install"]()
    end
  end,
})

-------------------------------------------------------------------------------
-- Install all plugins
-------------------------------------------------------------------------------
vim.pack.add({
  -- Dependencies (loaded first)
  gh("nvim-lua/plenary.nvim"),
  gh("MunifTanjim/nui.nvim"),
  gh("nvim-tree/nvim-web-devicons"),
  gh("nvim-neotest/nvim-nio"),

  -- Colorscheme
  { src = gh("catppuccin/nvim"), name = "catppuccin" },

  -- UI
  gh("akinsho/bufferline.nvim"),
  { src = gh("echasnovski/mini.bufremove"), name = "mini.bufremove" },
  gh("nvim-lualine/lualine.nvim"),
  gh("folke/which-key.nvim"),
  gh("rcarriga/nvim-notify"),
  gh("folke/noice.nvim"),
  gh("folke/snacks.nvim"),

  -- File explorer
  { src = gh("nvim-neo-tree/neo-tree.nvim"), version = vim.version.range("3.0") },

  -- Telescope
  gh("nvim-telescope/telescope.nvim"),
  { src = gh("nvim-telescope/telescope-fzf-native.nvim"), name = "telescope-fzf-native.nvim" },

  -- Treesitter
  gh("nvim-treesitter/nvim-treesitter"),
  { src = gh("nvim-treesitter/nvim-treesitter-textobjects"), version = "main" },

  -- Completion
  gh("hrsh7th/nvim-cmp"),
  gh("hrsh7th/cmp-nvim-lsp"),
  gh("hrsh7th/cmp-buffer"),
  gh("hrsh7th/cmp-path"),

  -- Formatting
  gh("stevearc/conform.nvim"),

  -- Git
  gh("f-person/git-blame.nvim"),
  gh("kdheepak/lazygit.nvim"),

  -- DAP (debugging)
  gh("mfussenegger/nvim-dap"),
  gh("rcarriga/nvim-dap-ui"),
  gh("mfussenegger/nvim-dap-python"),

  -- AI / Copilot
  gh("github/copilot.vim"),

  -- Editing
  gh("tpope/vim-commentary"),
  { src = gh("echasnovski/mini.ai"), name = "mini.ai" },

  -- Markdown
  gh("iamcco/markdown-preview.nvim"),

  -- Python
  gh("benomahony/uv.nvim"),

  -- Opencode
  gh("NickvanDyke/opencode.nvim"),
}, { confirm = false })

-------------------------------------------------------------------------------
-- Colorscheme
-------------------------------------------------------------------------------
vim.cmd.colorscheme("catppuccin-macchiato")

-------------------------------------------------------------------------------
-- Bufferline
-------------------------------------------------------------------------------
require("bufferline").setup({
  options = {
    diagnostics = "nvim_lsp",
    always_show_bufferline = false,
    offsets = {
      {
        filetype = "neo-tree",
        text = "Neo-tree",
        highlight = "Directory",
        text_align = "left",
      },
    },
  },
})

-------------------------------------------------------------------------------
-- Lualine
-------------------------------------------------------------------------------
require("lualine").setup({
  options = {
    theme = "auto",
    globalstatus = true,
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

-------------------------------------------------------------------------------
-- Which-key
-------------------------------------------------------------------------------
require("which-key").setup({})

-------------------------------------------------------------------------------
-- Noice
-------------------------------------------------------------------------------
require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  routes = {
    -- Suppress the DSR terminal detection warning (nvim 0.12 + cmdheight=0)
    {
      filter = {
        event = "notify",
        find = "Did not detect DSR response",
      },
      opts = { skip = true },
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = false,
  },
})

-------------------------------------------------------------------------------
-- Snacks
-------------------------------------------------------------------------------
require("snacks").setup({
  input = { enabled = true },
})

-------------------------------------------------------------------------------
-- Neo-tree (setup deferred to avoid <afile> errors with cmdheight=0)
-------------------------------------------------------------------------------
local neo_tree_configured = false
function M.ensure_neo_tree()
  if neo_tree_configured then
    return
  end
  neo_tree_configured = true
  require("neo-tree").setup({
    filesystem = {
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    },
    window = {
      position = "left",
      width = 30,
    },
    default_component_configs = {
      diagnostics = {
        symbols = {
          hint = "",
          info = "",
          warn = "",
          error = "",
        },
      },
    },
  })
end

-- Open neo-tree when starting nvim with a directory
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
  desc = "Start Neo-tree with directory",
  callback = function()
    local arg = vim.fn.argv(0)
    if arg ~= "" then
      local stats = vim.uv.fs_stat(arg)
      if stats and stats.type == "directory" then
        M.ensure_neo_tree()
        vim.cmd("Neotree dir=" .. vim.fn.fnameescape(arg))
      end
    end
  end,
})

-- Also ensure setup runs before any :Neotree command
vim.api.nvim_create_autocmd("CmdUndefined", {
  pattern = "Neotree*",
  once = true,
  callback = function()
    M.ensure_neo_tree()
  end,
})

-------------------------------------------------------------------------------
-- Telescope
-------------------------------------------------------------------------------
local telescope = require("telescope")
local actions = require("telescope.actions")

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
      find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
    },
    live_grep = {
      additional_args = function()
        return { "--hidden", "-g", "!.git" }
      end,
    },
  },
})

telescope.load_extension("fzf")

-------------------------------------------------------------------------------
-- Treesitter
-- nvim 0.12 has built-in treesitter highlighting. nvim-treesitter now just
-- provides :TSInstall/:TSUpdate commands for parser management.
-- Run :TSInstall python lua terraform hcl vim vimdoc markdown  on first use.
-------------------------------------------------------------------------------
require("nvim-treesitter.config").setup()

-------------------------------------------------------------------------------
-- LSP (native nvim 0.12 — no plugins needed)
-- Install servers yourself:
--   brew install pyright
--   uv tool install ruff
--   brew install hashicorp/tap/terraform-ls
-------------------------------------------------------------------------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = { "pyright", "ruff", "terraformls" }
for _, name in ipairs(servers) do
  local config = require("lsp." .. name)
  config.capabilities = capabilities
  vim.lsp.config[name] = config
  vim.lsp.enable(name)
end

vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    prefix = "●",
  },
  severity_sort = true,
  signs = false,
  float = {
    border = "rounded",
    source = "always",
  },
})

vim.api.nvim_create_user_command("DiagnosticsToggle", function()
  local current = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({
    virtual_text = not current and {
      spacing = 4,
      prefix = "●",
    } or false,
  })
end, {})

-------------------------------------------------------------------------------
-- nvim-cmp
-------------------------------------------------------------------------------
local cmp = require("cmp")

cmp.setup({
  completion = {
    completeopt = "menu,menuone,noinsert",
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "path" },
  }, {
    { name = "buffer" },
  }),
})

-------------------------------------------------------------------------------
-- Conform (formatting)
-------------------------------------------------------------------------------
local conform = require("conform")

local black_path = "./.venv/bin/black"
local ruff_path = "./.venv/bin/ruff"

conform.setup({
  formatters = {
    black_local = {
      command = black_path,
      args = { "-" },
      stdin = true,
    },
    ruff_local = {
      command = ruff_path,
      args = { "format", "-" },
      stdin = true,
    },
    ruff_uv = {
      command = "uv",
      args = { "run", "ruff", "format", "-" },
      stdin = true,
      cwd = require("conform.util").root_file({ "pyproject.toml" }),
    },
  },
  formatters_by_ft = {
    lua = { "stylua" },
    python = function()
      if vim.fn.filereadable(black_path) == 1 then
        return { "black_local" }
      elseif vim.fn.filereadable(ruff_path) == 1 then
        return { "ruff_local" }
      else
        return { "ruff_uv" }
      end
    end,
    terraform = { "terraform_fmt" },
    tf = { "terraform_fmt" },
    ["terraform-vars"] = { "terraform_fmt" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

-------------------------------------------------------------------------------
-- Git blame
-------------------------------------------------------------------------------
require("gitblame").setup({
  enabled = true,
  message_template = " <summary> • <date> • <author>",
  date_format = "%r",
  virtual_text_column = 1,
})

-------------------------------------------------------------------------------
-- DAP (debugging)
-------------------------------------------------------------------------------
local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

require("dap-python").setup("uv")
dap.configurations.python = {
  {
    type = "python",
    request = "attach",
    name = "Docker Remote Attach",
    connect = {
      host = "localhost",
      port = 9001,
    },
    pathMappings = {
      {
        localRoot = vim.fn.getcwd(),
        remoteRoot = "/application",
      },
    },
  },
  {
    type = "python",
    request = "launch",
    name = "Launch File",
    program = "${file}",
    justMyCode = false,
    pythonPath = function()
      return "python"
    end,
  },
}

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-------------------------------------------------------------------------------
-- mini.ai
-------------------------------------------------------------------------------
local ai = require("mini.ai")
ai.setup({
  n_lines = 500,
  custom_textobjects = {
    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
    o = ai.gen_spec.treesitter({
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }),
  },
})

-------------------------------------------------------------------------------
-- mini.bufremove
-------------------------------------------------------------------------------
require("mini.bufremove").setup()

-------------------------------------------------------------------------------
-- uv.nvim
-------------------------------------------------------------------------------
require("uv").setup({
  notify_activate_venv = false,
})

-------------------------------------------------------------------------------
-- Opencode
-------------------------------------------------------------------------------
vim.g.opencode_opts = {}

-------------------------------------------------------------------------------
-- See active LSP clients
-------------------------------------------------------------------------------
vim.api.nvim_create_user_command("LspClients", function()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })) do
    print("Active LSP: " .. client.name)
  end
end, {})

return M
