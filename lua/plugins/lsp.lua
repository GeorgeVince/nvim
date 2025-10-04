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

      local lspconfig = require("lspconfig")

      local pyright_config = require("lsp.pyright")
      lspconfig.pyright.setup(pyright_config)

      local ruff_config = require("lsp.ruff")
      lspconfig.ruff.setup(ruff_config)
    end,
  },
}
