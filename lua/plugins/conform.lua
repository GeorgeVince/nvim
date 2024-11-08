-- Use the local black formatter if it exists, otherwise use the ruff_format formatter
return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    -- Ensure the formatters table exists
    opts.formatters = opts.formatters or {}

    local black_path = "./.venv/bin/black"
    -- Define a custom formatter 'black_local' that uses the local black executable
    opts.formatters.black_local = {
      command = black_path,
      args = { "-" },
      stdin = true,
    }

    -- Ensure the formatters_by_ft table exists
    opts.formatters_by_ft = opts.formatters_by_ft or {}

    opts.formatters_by_ft.python = function(bufnr)
      if vim.fn.filereadable(black_path) == 1 then
        vim.notify("Using local black formatter")
        return { "black_local" }
      else
        vim.notify("Using ruff_fix formatter")
        return { "ruff_format" }
      end
    end
  end,
}
