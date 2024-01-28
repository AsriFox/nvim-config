local on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementations')
  nmap('<leader>sT', require('telescope.builtin').lsp_type_definitions, '[T]ype definitions')
  nmap('<leader>ss', require('telescope.builtin').lsp_document_symbols, 'Document symbols')
  nmap('<leader>sS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace symbols')
  nmap('K', vim.lsp.buf.hover, 'Hover documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature documentation')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace: [A]dd directory')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace: [R]emove directory')
  nmap('<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, '[W]orkspace: [L]ist directories')
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_) vim.lsp.buf.format() end, { desc = 'Format current buffer with LSP' })
end

return {
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      { 'williamboman/mason.nvim', config = true },
      'hrsh7th/cmp-nvim-lsp',
      'SmiteshP/nvim-navic',
    },
    config = function(_, _)
      require('mason').setup()
      local mason_lsp = require 'mason-lspconfig'
      mason_lsp.setup()

      local servers = {
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
              disable = { 'missing-fields' },
              globals = { 'vim', 'bit' },
            },
          },
        },
      }
      mason_lsp.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      mason_lsp.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
          }
        end,
      }
    end,
  },
}
