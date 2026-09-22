return {
  -- 1. Security-Specific Static Analysis & Linter Config
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
        python = { "bandit" },
        -- LazyVim's markdown extra installs markdownlint-cli2, not markdownlint
        markdown = { "markdownlint-cli2" },
      },
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", vim.fn.stdpath("config") .. "/.markdownlint-cli2.jsonc", "-" },
        },
      },
    },
  },

  -- 2. Binary & Memory Investigation
  {
    "RaafatTurki/hex.nvim",
    cmd = { "HexDump", "HexAssemble", "HexToggle" },
    config = true,
  },

  -- 5. Obsidian for CTF notes/Documentation
  {
    "epwalsh/obsidian.nvim",
    enabled = false,
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        {
          name = "CTF",
          path = "~/obsidian/ctf",
        },
      },
    },
  },
}
