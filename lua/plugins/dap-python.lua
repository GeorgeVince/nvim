return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      local venvPath = os.getenv("VENV")
      local pythonPath = venvPath and venvPath .. "/bin/python" or "python"
      -- Ensure the dap.configurations.python table exists
      dap.configurations.python = dap.configurations.python or {}

      table.insert(dap.configurations.python, {
        justMyCode = false,
        type = "python",
        request = "launch",
        name = "Python Debug Poetry",
        program = "${file}",
        pythonPath = pythonPath,
      })
    end,
  },
}
