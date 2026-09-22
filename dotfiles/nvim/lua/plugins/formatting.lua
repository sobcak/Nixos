return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      -- Explicitly ignore snacks buffers or other non-code types
      ["snacks_notif"] = {},
      ["snacks_picker"] = {},

      -- Your actual code formatters
      python = { "ruff" },
      cs = { "csharpier" },
    },
  },
}
