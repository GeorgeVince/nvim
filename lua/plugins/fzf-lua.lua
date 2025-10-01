return {
  "ibhagwan/fzf-lua",
  opts = {
    actions = {
      files = {
        ["ctrl-h"] = require("fzf-lua").actions.toggle_hidden,
      },
    },
  },
}
