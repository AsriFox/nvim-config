return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      flavour = 'macchiato',
      transparent_background = true,
      integrations = {
        cmp = true,
        dap = true,
        dap_ui = true,
        dashboard = true,
        gitsigns = true,
        mason = true,
        treesitter = true,
        telescope = { enabled = true },
        which_key = true,
      },
    },
  },
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    opts = {
      theme = 'hyper',
      config = {
        shortcut = {
          {
            desc = '󰊳 Update',
            group = '@property',
            action = 'Lazy update',
            key = 'u',
          },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Files',
            group = 'Label',
            action = 'Telescope find_files',
            key = 'f',
          },
        },
      },
    },
  },
  {
    'stevearc/dressing.nvim',
    lazy = true,
  },
  {
    'j-hui/fidget.nvim',
    opts = {},
  },
}
