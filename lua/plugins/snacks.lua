return {
  "folke/snacks.nvim",
  opts = {
    input = { enabled = true },
  },
  keys = {
    {
      "<leader>go",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Open in Browser",
      mode = { "n", "x" },
    },
    {
      "<leader>gm",
      function()
        Snacks.gitbrowse({ branch = "main" })
      end,
      desc = "Git Open main in Browser",
      mode = { "n", "x" },
    },
  },
}
