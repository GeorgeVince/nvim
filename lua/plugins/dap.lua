return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
    },
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>ds",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.open()
        end,
        desc = "Open REPL",
      },
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle DAP UI",
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      require("dap-python").setup("python")
      dap.configurations.python = {
        {
          type = "python",
          request = "attach",
          name = "Docker Remote Attach",
          connect = {
            host = "localhost",
            port = 5678,
          },
          pathMappings = {
            {
              localRoot = vim.fn.getcwd(),
              remoteRoot = "/app",
            },
          },
        },
        {
          type = "python",
          request = "launch",
          name = "Launch File",
          program = "${file}",
          pythonPath = function()
            return "python"
          end,
        },
      }
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
