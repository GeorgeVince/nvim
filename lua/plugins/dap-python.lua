return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "theHamsta/nvim-dap-virtual-text" },

    config = function()
      -- Your dap configuration here
      local dap = require("dap")
      dap.configurations.python = {
        {
          type = "python", -- the type of debugger to use
          request = "launch",
          name = "Python Debug Prefect",
          program = "${file}", -- This specifies the current file should be used.
          pythonPath = function()
            -- Return the path to the python executable you want to use for debugging
            return "/Users/georgevince/Library/Caches/pypoetry/virtualenvs/flows-Iom276GZ-py3.9/bin/python"
          end,
        },
      }
    end,
  },
}
