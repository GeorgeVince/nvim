return {
  -- disable pyright mason, we just want to use ruff.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          mason = false,
          autostart = false,
        },
        ruff_lsp = {},
        rust_analyzer = {},
      },
    },
  },
}
