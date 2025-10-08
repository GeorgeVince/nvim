-- nvim v0.8.0
return {
  "kdheepak/lazygit.nvim",
  lazy = true,
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  -- optional for floating window border decoration
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- setting the keybinding for LazyGit with 'keys' is recommended in
  -- order to load the plugin when the command is run for the first time
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  },
  config = function()
    -- Disable tmux navigator keys when in lazygit terminal
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*",
      callback = function()
        local cmd = vim.fn.expand("<afile>")
        if string.match(cmd, "lazygit") then
          -- Override tmux navigator keys to pass through to lazygit
          vim.keymap.set("t", "<c-j>", "<c-j>", { buffer = true })
          vim.keymap.set("t", "<c-k>", "<c-k>", { buffer = true })
        end
      end,
    })
  end,
}
