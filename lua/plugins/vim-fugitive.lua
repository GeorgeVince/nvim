return {
  { "tpope/vim-fugitive", version = "*" },
  {
    "tpope/vim-rhubarb",
    keys = {
      { "<leader>gb", "<cmd>GBrowse<cr>", mode = "n", desc = "Open in Browser" }, -- Normal mode
      { "<leader>gb", ":GBrowse<cr>", mode = "v", desc = "Open in Browser (Visual)" }, -- Visual mode
    },
    version = "*",
  },
}
