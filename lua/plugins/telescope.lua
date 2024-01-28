return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    version = false,
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      enabled = vim.fn.executable 'make' == 1,
      config = function()
        -- Util.on_load('telescope.nvim', function()
        --   require('telescope').load_extension('fzf')
        -- end)
      end,
    },
    keys = {
      {
        '<leader>,',
        '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>',
        desc = 'Switch buffer',
      },
      { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
      { '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent files' },
      { '<leader>s"', '<cmd>Telescope registers<cr>', desc = 'Registers' },
      {
        '<leader>sd',
        '<cmd>Telescope diagnostics bufnr=0<cr>',
        desc = 'Document diagnostics',
      },
      {
        '<leader>sD',
        '<cmd>Telescope diagnostics<cr>',
        desc = 'Workspace diagnostics',
      },
      { '<leader>sm', '<cmd>Telescope marks<cr>', desc = 'Jump to mark' },
    },
    opts = {
      prompt_prefix = ' ',
      selection_caret = ' ',
    },
  },
}
