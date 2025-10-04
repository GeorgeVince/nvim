return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "ruff" },
      })

      local pyright_config = require("lsp.pyright")
      vim.lsp.config.pyright = pyright_config
      vim.lsp.enable('pyright')

      local ruff_config = require("lsp.ruff")
      vim.lsp.config.ruff = ruff_config
      vim.lsp.enable('ruff')

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
    end,
  },
}
