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
        ensure_installed = { "pyright", "ruff", "terraformls" },
      })

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local pyright_config = require("lsp.pyright")
      pyright_config.capabilities = capabilities
      vim.lsp.config.pyright = pyright_config
      vim.lsp.enable('pyright')

      local ruff_config = require("lsp.ruff")
      ruff_config.capabilities = capabilities
      vim.lsp.config.ruff = ruff_config
      vim.lsp.enable('ruff')

      vim.lsp.config.terraformls = {
        cmd = { 'terraform-ls', 'serve' },
        filetypes = { 'terraform', 'tf' },
        capabilities = capabilities,
      }
      vim.lsp.enable('terraformls')

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

      vim.api.nvim_create_user_command('DiagnosticsToggle', function()
        local current = vim.diagnostic.config().virtual_text
        vim.diagnostic.config({
          virtual_text = not current and {
            spacing = 4,
            prefix = "●",
          } or false
        })
      end, {})
    end,
  },
}
