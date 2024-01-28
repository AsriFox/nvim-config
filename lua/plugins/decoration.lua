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
        illuminate = {
          enabled = true,
          lsp = false,
        },
        indent_blankline = {
          enabled = true,
          scope_color = '',
          colored_indent_levels = false,
        },
        mini = {
          enabled = true,
          indentscope_color = '',
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { 'italic' },
            hints = { 'italic' },
            warnings = { 'italic' },
            information = { 'italic' },
          },
          underlines = {
            errors = { 'underline' },
            hints = { 'underline' },
            warnings = { 'underline' },
            information = { 'underline' },
          },
          inlay_hints = {
            background = true,
          },
        },
        mason = true,
        treesitter = true,
        telescope = { enabled = true },
        which_key = true,
      },
    },
  },
  {
    'nvimdev/dashboard-nvim',
    dependencies = {
      'folke/persistence.nvim',
      event = 'BufReadPre',
      opts = { options = vim.opt.sessionoptions:get() },
      keys = {
        {
          '<leader>qs',
          function() require('persistence').load {} end,
          desc = 'Restore session',
        },
        {
          '<leader>ql',
          function() require('persistence').load { last = true } end,
          desc = 'Restore last session',
        },
        {
          '<leader>qd',
          function() require('persistence').stop {} end,
          desc = "Don't save current session",
        },
      },
    },
    event = 'VimEnter',
    opts = {
      config = {
        shortcut = {
          {
            desc = '󰒲 Update',
            group = '@property',
            action = 'Lazy update',
            key = 'u',
          },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Session restore',
            group = 'Label',
            action = 'lua require("persistence").load()',
            key = 's',
          },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Files',
            group = 'Label',
            action = 'Telescope find_files',
            key = 'f',
          },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Recent',
            group = 'Label',
            action = 'Telescope oldfiles',
            key = 'r',
          },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Quit',
            group = 'Label',
            action = 'qa',
            key = 'q',
          },
        },
        packages = { enabled = false },
        footer = {},
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
