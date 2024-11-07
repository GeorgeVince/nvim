return {
  "nvim-neotest/neotest",
  requires = {
    "nvim-neotest/neotest-python",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python")({
          runner = "pytest", -- Set pytest as the runner
        }),
      },
    })
  end,
}
