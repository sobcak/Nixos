-- Forcibly apply "The Void" Monochromatic Aesthetic
local function apply_void_theme()
  local colors = {
    black = "#000000",
    silver = "#c5c8c6",
    white = "#ffffff",
    grey_light = "#aaaaaa",
    grey_dark = "#444444",
    red = "#ff0000",
    orange = "#ff8700",
  }

  local highlights = {
    -- Base
    Normal = { fg = colors.silver, bg = colors.black },
    NormalFloat = { fg = colors.silver, bg = colors.black },
    FloatBorder = { fg = colors.white, bg = colors.black },
    CursorLine = { bg = "#111111" },
    LineNr = { fg = colors.grey_dark },
    CursorLineNr = { fg = colors.white, bold = true },
    WinSeparator = { fg = colors.grey_dark },

    -- Snacks Dashboard
    SnacksDashboardHeader = { fg = colors.white },
    SnacksDashboardIcon = { fg = colors.white },
    SnacksDashboardDesc = { fg = colors.silver },
    SnacksDashboardKey = { fg = colors.white, bold = true },
    SnacksDashboardDir = { fg = colors.grey_dark },

    -- Noice
    NoiceCmdlinePopup = { bg = colors.black, fg = colors.silver },
    NoiceCmdlinePopupBorder = { fg = colors.white, bg = colors.black },
    NoiceCmdlinePopupBorderCmdline = { fg = colors.white, bg = colors.black },
    NoiceCmdlinePopupBorderSearch = { fg = colors.white, bg = colors.black },
    NoicePopupmenu = { bg = colors.black, fg = colors.silver },
    NoicePopupmenuBorder = { fg = colors.grey_dark, bg = colors.black },
    NoicePopupmenuSelected = { bg = colors.white, fg = colors.black },
    NoiceCmdlineIcon = { fg = colors.red },
    NoiceCmdlineIconCmdline = { fg = colors.red },
    NoiceCmdlinePrompt = { fg = colors.red },
  }

  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

-- Re-apply on colorscheme change (LazyVim loads themes late)
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    apply_void_theme()
  end,
})

-- Markdown: Conceal raw syntax and enable bilingual spellcheck
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.conceallevel = 2
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en", "cs" }
  end,
})

-- Initial application
apply_void_theme()
