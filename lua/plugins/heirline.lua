local left_sep = ''
local right_sep = ''

local statusline = function()
  local conditions = require 'heirline.conditions'

  local vim_mode = {
    static = {
      mode_names = {
        n = 'N',
        no = 'N?',
        nov = 'N?',
        noV = 'N?',
        ['no\22'] = 'N?',
        niI = 'Ni',
        niR = 'Nr',
        niV = 'Nv',
        nt = 'Nt',
        v = 'V',
        vs = 'Vs',
        V = 'V_',
        Vs = 'Vs',
        ['\22'] = '^V',
        ['\22s'] = '^V',
        s = 'S',
        S = 'S_',
        ['\19'] = '^S',
        i = 'I',
        ic = 'Ic',
        ix = 'Ix',
        R = 'R',
        Rc = 'Rc',
        Rx = 'Rx',
        Rv = 'Rv',
        Rvc = 'Rv',
        Rvx = 'Rv',
        c = 'C',
        cv = 'Ex',
        r = '...',
        rm = 'M',
        ['r?'] = '?',
        ['!'] = '!',
        t = 'T',
      },
      mode_colors = {
        n = 'lavender',
        i = 'green',
        v = 'flamingo',
        V = 'flamingo',
        ['\22'] = 'maroon',
        c = 'peach',
        s = 'maroon',
        S = 'maroon',
        ['\19'] = 'maroon',
        R = 'teal',
        r = 'teal',
        ['!'] = 'green',
        t = 'green',
      },
    },
    init = function(self) self.mode = vim.fn.mode(1) end,
    update = {
      'ModeChanged',
      pattern = '*:*',
      callback = vim.schedule_wrap(function() vim.cmd 'redrawstatus' end),
    },
    {
      provider = function(self) return '%2(' .. self.mode_names[self.mode] .. '%)' end,
      hl = function(self)
        local mode = self.mode:sub(1, 1)
        return {
          bg = self.mode_colors[mode],
          fg = 'mantle',
          bold = true,
        }
      end,
    },
    {
      provider = right_sep .. ' ',
      hl = function(self)
        local mode = self.mode:sub(1, 1)
        return { fg = self.mode_colors[mode] }
      end,
    },
  }

  local ruler = {
    provider = '%l:%2c',
    hl = { fg = 'text' },
  }

  local lsp_active = {
    condition = conditions.lsp_attached,
    update = { 'LspAttach', 'LspDetach' },
    provider = function()
      local names = {}
      for _, server in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
        table.insert(names, server.name)
      end
      return ' [' .. table.concat(names, ' ') .. ']'
    end,
    hl = { fg = 'green' },
  }

  local diagnostics = {
    condition = conditions.has_diagnostics,
    static = {
      error_icon = '',
      warn_icon = '',
      info_icon = '',
      hint_icon = '',
    },
    init = function(self)
      self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,
    update = { 'DiagnosticChanged', 'BufEnter' },
    {
      provider = function(self) return self.errors > 0 and (self.error_icon .. ' ' .. self.errors .. ' ') end,
      hl = { fg = 'red' },
    },
    {
      provider = function(self) return self.warnings > 0 and (self.warn_icon .. ' ' .. self.warnings .. ' ') end,
      hl = { fg = 'yellow' },
    },
    {
      provider = function(self) return self.info > 0 and (self.info_icon .. ' ' .. self.info .. ' ') end,
      hl = { fg = 'sky' },
    },
    {
      provider = function(self) return self.hints > 0 and (self.hint_icon .. ' ' .. self.hints .. ' ') end,
      hl = { fg = 'rosewater' },
    },
  }

  local git_status = {
    condition = conditions.is_git_repo,
    init = function(self)
      self.status_dict = vim.b.gitsigns_status_dict
      self.has_changes = (self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0)
    end,
    hl = { fg = 'mauve' },
    {
      provider = function(self) return ' ' .. self.status_dict.head end,
      hl = { bold = true },
    },
    {
      condition = function(self) return self.has_changes end,
      provider = '(',
    },
    {
      provider = function(self)
        local count = self.status_dict.added or 0
        return count > 0 and ('+' .. count)
      end,
      hl = { fg = 'green' },
    },
    {
      provider = function(self)
        local count = self.status_dict.removed or 0
        return count > 0 and ('-' .. count)
      end,
      hl = { fg = 'red' },
    },
    {
      provider = function(self)
        local count = self.status_dict.changed or 0
        return count > 0 and ('~' .. count)
      end,
      hl = { fg = 'sapphire' },
    },
    {
      condition = function(self) return self.has_changes end,
      provider = ')',
    },
  }

  local work_dir = {
    init = function(self)
      --self.icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
      self.icon = ' '
      local cwd = vim.fn.getcwd(0)
      self.cwd = vim.fn.fnamemodify(cwd, ':~')
      if not conditions.width_percent_below(#cwd, 0.25) then cwd = vim.fn.pathshorten(cwd) end
    end,
    hl = {
      bg = 'flamingo',
      fg = 'mantle',
      bold = true,
    },
    flexible = 1,
    {
      provider = function(self)
        local trail = self.cwd:sub(-1) == '/' and '' or '/'
        return self.icon .. self.cwd .. trail .. ' '
      end,
    },
    {
      provider = function(self)
        local cwd = vim.fn.pathshorten(self.cwd)
        local trail = self.cwd:sub(-1) == '/' and '' or '/'
        return self.icon .. cwd .. trail .. ' '
      end,
    },
    { provider = '' },
  }

  return {
    vim_mode,
    git_status,
    { provider = '%=' },
    lsp_active,
    { provider = ' ' },
    diagnostics,
    { provider = '%=' },
    ruler,
    {
      provider = ' ' .. left_sep,
      hl = { fg = 'flamingo' },
    },
    work_dir,
  }
end

local winbar = function()
  local navic = require 'nvim-navic'
  local crumbs = {
    static = {
      type_hl = {
        File = 'Directory',
        Module = '@include',
        Namespace = '@namespace',
        Package = '@include',
        Class = '@structure',
        Method = '@method',
        Property = '@property',
        Field = '@field',
        Constructor = '@constructor',
        Enum = '@field',
        Interface = '@type',
        Function = '@function',
        Variable = '@variable',
        Constant = '@constant',
        String = '@string',
        Number = '@number',
        Boolean = '@boolean',
        Array = '@field',
        Object = '@type',
        Key = '@keyword',
        Null = '@comment',
        EnumMember = '@field',
        Struct = '@structure',
        Event = '@keyword',
        Operator = '@operator',
        TypeParameter = '@type',
      },
      enc = function(line, col, winnr) return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr) end,
      dec = function(c)
        local line = bit.rshift(c, 16)
        local col = bit.band(bit.rshift(c, 6), 1023)
        local winnr = bit.band(c, 63)
        return line, col, winnr
      end,
    },
    init = function(self)
      local data = navic.get_data() or {}
      local children = {}
      -- create a child for each level
      for i, d in ipairs(data) do
        -- encode line and column numbers into a single integer
        local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
        local child = {
          {
            provider = d.icon,
            hl = self.type_hl[d.type],
          },
          {
            -- escape `%`s (elixir) and buggy default separators
            provider = d.name:gsub('%%', '%%%%'):gsub('%s*->%s*', ''),
            -- highlight icon only or location name as well
            -- hl = self.type_hl[d.type],

            on_click = {
              -- pass the encoded position through minwid
              minwid = pos,
              callback = function(_, minwid)
                local line, col, winnr = self.dec(minwid)
                vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { line, col })
              end,
              name = 'heirline_navic',
            },
          },
        }
        -- add a separator only if needed
        if #data > 1 and i < #data then
          table.insert(child, {
            provider = ' > ',
            hl = { fg = 'text' },
          })
        end
        table.insert(children, child)
      end
      -- instantiate the new child, overwriting the previous one
      self.child = self:new(children, 1)
    end,
    -- evaluate the children containing navic components
    provider = function(self) return self.child:eval() end,
    hl = { bg = 'surface1' },
    update = 'CursorMoved',
  }

  return {
    fallthrough = false,
    {
      condition = function() return navic.is_available() end,
      crumbs,
      {
        provider = '%=',
        hl = { bg = 'surface1' },
      },
    },
  }
end

local tabline = function()
  local utils = require 'heirline.utils'

  local file_icon = {
    init = function(self)
      local filename = self.filename
      local extension = vim.fn.fnamemodify(filename, ':e')
      self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
    end,
    provider = function(self) return self.icon and (self.icon .. ' ') end,
    hl = function(self) return { fg = self.icon_color } end,
  }

  local file_name = {
    provider = function(self)
      local filename = self.filename
      filename = filename == '' and '[無名]' or vim.fn.fnamemodify(filename, ':t')
      return filename
    end,
    hl = function(self) return { bold = self.is_active or self.is_visible } end,
  }

  local file_flags = {
    {
      condition = function(self) return vim.api.nvim_buf_get_option(self.bufnr, 'modified') end,
      provider = '[+]',
      hl = { fg = 'green' },
    },
    {
      condition = function(self)
        return not vim.api.nvim_buf_get_option(self.bufnr, 'modifiable')
          or vim.api.nvim_buf_get_option(self.bufnr, 'readonly')
      end,
      provider = function(self)
        if vim.api.nvim_buf_get_option(self.bufnr, 'buftype') == 'terminal' then
          return '  '
        else
          return ''
        end
      end,
      hl = { fg = 'maroon' },
    },
  }

  local file_name_block = {
    init = function(self) self.filename = vim.api.nvim_buf_get_name(self.bufnr) end,
    hl = function(self)
      if self.is_active then
        return 'TabLineSel'
      else
        return 'TabLine'
      end
    end,
    on_click = {
      callback = function(_, minwid, _, button)
        if button == 'm' then
          vim.schedule(function() vim.api.nvim_buf_delete(minwid, { force = false }) end)
        else
          vim.api.nvim_win_set_buf(0, minwid)
        end
      end,
      minwid = function(self) return self.bufnr end,
      name = 'heirline_tabline_buffer_callback',
    },
    file_icon,
    file_name,
    file_flags,
  }

  local close_button = {
    condition = function(self) return not vim.api.nvim_buf_get_option(self.bufnr, 'modified') end,
    { provider = ' ' },
    {
      provider = 'x',
      hl = { fg = 'base' },
      on_click = {
        callback = function(_, minwid)
          vim.schedule(function()
            vim.api.nvim_buf_delete(minwid, { force = false })
            vim.cmd.redrawtabline()
          end)
        end,
        minwid = function(self) return self.bufnr end,
        name = 'heirline_tabline_close_buffer_callback',
      },
    },
  }

  local tab_block = utils.surround({ '', '' }, function(self)
    if self.is_active then
      return utils.get_highlight('TabLineSel').bg
    else
      return utils.get_highlight('TabLine').bg
    end
  end, { file_name_block, close_button })

  return utils.make_buflist(
    tab_block,
    { provider = '', hl = { fg = 'gray' } },
    { provider = '', hl = { fg = 'gray' } }
  )
end

return {
  {
    'rebelot/heirline.nvim',
    dependencies = {
      'catppuccin/nvim',
      'nvim-tree/nvim-web-devicons',
      'lewis6991/gitsigns.nvim',
      'SmiteshP/nvim-navic',
    },
    event = 'UiEnter',
    opts = function()
      local palette = require('catppuccin.palettes').get_palette 'macchiato'

      return {
        statusline = statusline(),
        winbar = winbar(),
        tabline = tabline(),
        --statuscolumn = statuscolumn,
        opts = {
          colors = palette,
        },
      }
    end,
  },
}
