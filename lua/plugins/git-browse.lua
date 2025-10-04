return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "GBrowse" },
    keys = {
      { "<leader>go", "<cmd>GBrowse<cr>", desc = "Git Open in Browser", mode = { "n", "v" } },
      { "<leader>gm", "<cmd>GBrowse main:%<cr>", desc = "Git Open main in Browser", mode = { "n", "v" } },
    },
  },
  {
    "tpope/vim-rhubarb",
    dependencies = { "tpope/vim-fugitive" },
  },
}
