-- NixOS: Mason's generic/npm packages often cannot run (stub-ld / missing npm).
-- Prefer Nix-built CLIs and skip Mason for servers we install from nixpkgs.

local nix_path_dirs = {
  "/run/current-system/sw/bin",
  vim.fn.expand("~/.nix-profile/bin"),
}

local function prepend_nix_path()
  for i = #nix_path_dirs, 1, -1 do
    local dir = nix_path_dirs[i]
    if vim.fn.isdirectory(dir) == 1 and vim.env.PATH:sub(1, #dir + 1) ~= (dir .. ":") then
      vim.env.PATH = dir .. ":" .. (vim.env.PATH or "")
    end
  end
end

local function drop_mason_shim(name)
  local shim = vim.fn.stdpath("data") .. "/mason/bin/" .. name
  if vim.uv.fs_stat(shim) then
    vim.uv.fs_unlink(shim)
  end
end

prepend_nix_path()

return {
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = function(_, opts)
      -- Mason prepends its bin during setup; put Nix back in front afterwards.
      vim.schedule(prepend_nix_path)
      return opts
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      drop_mason_shim("tree-sitter")
      prepend_nix_path()
      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Pyright is an npm package in Mason; use pkgs.pyright instead.
        pyright = { mason = false },
      },
    },
  },
}
