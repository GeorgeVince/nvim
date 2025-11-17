return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = function(_, opts)
    opts.formatters = opts.formatters or {}

    local black_path = "./.venv/bin/black"
    local ruff_path = "./.venv/bin/ruff"

    opts.formatters.black_local = {
      command = black_path,
      args = { "-" },
      stdin = true,
    }

    opts.formatters.ruff_local = {
      command = ruff_path,
      args = { "format", "-" },
      stdin = true,
    }

    opts.formatters.ruff_uv = {
      command = "uv",
      args = { "run", "ruff", "format", "-" },
      stdin = true,
      cwd = require("conform.util").root_file({ "pyproject.toml" }),
    }

    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters_by_ft.lua = { "stylua" }
    opts.formatters_by_ft.python = function(bufnr)
      if vim.fn.filereadable(black_path) == 1 then
        return { "black_local" }
      elseif vim.fn.filereadable(ruff_path) == 1 then
        return { "ruff_local" }
      else
        return { "ruff_uv" }
      end
    end
    opts.formatters_by_ft.terraform = { "terraform_fmt" }
    opts.formatters_by_ft.tf = { "terraform_fmt" }
    opts.formatters_by_ft["terraform-vars"] = { "terraform_fmt" }

    opts.format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    }
  end,
}
