return {
  -- Noice: Replicating the Rofi Theme for the Command Line
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        view = "cmdline_popup", -- Force the popup view
        format = {
          -- cmdline = { icon = ": " },
          search_down = { icon = "/ " },
          search_up = { icon = "? " },
        },
      },
      views = {
        cmdline_popup = {
          position = { row = "40%", col = "50%" },
          size = { width = 60, height = "auto" },
          border = {
            style = "single",
            padding = { 0, 1 },
          },
        },
        popupmenu = {
          relative = "editor",
          position = { row = "52%", col = "50%" },
          size = { width = 60, height = 10 },
          border = {
            style = "single",
            padding = { 0, 1 },
          },
        },
      },
    },
  },

  -- Custom Dashboard Header via Snacks (LazyVim default)
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
                           
  ___  _ _                 
 / _ \| (_)_   _____ _ __  
| | | | | \ \ / / _ \ '__| 
| |_| | | |\ V /  __/ |    
 \___/|_|_| \_/ \___|_|    
                           
]],
        },
      },
    },
  },

  -- Lualine: Minimalist Monochromatic
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.component_separators = { left = "", right = "" }
      opts.options.section_separators = { left = "", right = "" }
      opts.options.theme = "auto"
      opts.sections.lualine_a = { { "mode", color = { bg = "#c5c8c6", fg = "#000000", gui = "bold" } } }
      opts.sections.lualine_b = { "branch" }
      opts.sections.lualine_c = { "filetype", "filename" }
      opts.sections.lualine_x = {}
      opts.sections.lualine_y = { "progress" }
      opts.sections.lualine_z = { "location" }
      return opts
    end,
  },
}
