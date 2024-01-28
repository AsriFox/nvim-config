local LazyFile = { 'BufReadPost', 'BufNewFile', 'BufWritePre' }

return {
  {
    'RRethy/vim-illuminate',
    event = LazyFile,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = LazyFile,
    opts = {
      indent = { char = '▏' },
      scope = { enabled = false },
    },
  },
  {
    'numToStr/Comment.nvim',
    event = LazyFile,
    opts = {},
  },
  {
    'echasnovski/mini.pairs',
    event = 'InsertEnter',
    opts = {},
  },
  {
    'echasnovski/mini.surround',
    keys = function(_, keys)
      local mappings = {
        { 'gsa', mode = { 'n', 'v' }, desc = 'Add surrounding' },
        { 'gsd', desc = 'Delete surrounding' },
        { 'gsf', desc = 'Find surrounding end' },
        { 'gsF', desc = 'Find surrounding begin' },
        { 'gsh', desc = 'Highlight surrounding' },
        { 'gsr', desc = 'Replace surrounding' },
        { 'gsn', desc = 'Update `MiniSurround.config.n_lines`' },
      }
      return vim.list_extend(mappings, keys)
    end,
    opts = {},
  },
  {
    'echasnovski/mini.ai',
    dependencies = {
      'folke/which-key.nvim',
    },
    event = LazyFile,
    opts = function()
      local ai = require 'mini.ai'
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }, {}),
          f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
          c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
        },
      }
    end,
    config = function(_, opts)
      require('mini.ai').setup(opts)
      -- register all text objects with which-key
      local i = {
        [' '] = 'Whitespace',
        ['"'] = 'Balanced "',
        ["'"] = "Balanced '",
        ['`'] = 'Balanced `',
        ['('] = 'Balanced (',
        [')'] = 'Balanced ) including white-space',
        ['>'] = 'Balanced > including white-space',
        ['<lt>'] = 'Balanced <',
        [']'] = 'Balanced ] including white-space',
        ['['] = 'Balanced [',
        ['}'] = 'Balanced } including white-space',
        ['{'] = 'Balanced {',
        ['?'] = 'User Prompt',
        _ = 'Underscore',
        a = 'Argument',
        b = 'Balanced ), ], }',
        c = 'Class',
        f = 'Function',
        o = 'Block, conditional, loop',
        q = 'Quote `, ", \'',
        t = 'Tag',
      }
      local a = vim.deepcopy(i)
      for k, v in pairs(a) do
        a[k] = v:gsub(' including.*', '')
      end

      local ic = vim.deepcopy(i)
      local ac = vim.deepcopy(a)
      for key, name in pairs { n = 'Next', l = 'Last' } do
        i[key] = vim.tbl_extend('force', { name = 'Inside ' .. name .. ' textobject' }, ic)
        a[key] = vim.tbl_extend('force', { name = 'Around ' .. name .. ' textobject' }, ac)
      end
      require('which-key').register {
        mode = { 'o', 'x' },
        i = i,
        a = a,
      }
    end,
  },
}
