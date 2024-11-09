return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      -- Adapter configuration for Python using debugpy
      dap.adapters.python = {
        type = "server",
        host = "127.0.0.1",
        port = tonumber(os.getenv("APP_DEBUG_PORT")) or 5678,
      }

      local venvPath = os.getenv("VENV")
      local pythonPath = venvPath and venvPath .. "/bin/python" or "python"

      -- Ensure the dap.configurations.python table exists
      dap.configurations.python = dap.configurations.python or {}

      -- Existing configuration for launching scripts
      table.insert(dap.configurations.python, {
        justMyCode = false,
        type = "python",
        request = "launch",
        name = "Python Debug Poetry",
        program = "${file}",
        pythonPath = pythonPath,
      })

      -- Configuration for attaching to the Docker container
      table.insert(dap.configurations.python, {
        type = "python",
        request = "attach",
        name = "9app Debug",
        host = "127.0.0.1",
        port = tonumber(os.getenv("APP_DEBUG_PORT")) or 5678,
        pathMappings = {
          {
            localRoot = vim.fn.getcwd(),
            remoteRoot = "/application",
          },
        },
      })
    end,
  },
}
