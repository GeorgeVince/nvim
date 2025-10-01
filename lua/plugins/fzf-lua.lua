return {
  "ibhagwan/fzf-lua",
  opts = {
    actions = {
      files = {
        true,
        ["ctrl-h"] = require("fzf-lua").actions.toggle_hidden,
      },
    },
  },
}
