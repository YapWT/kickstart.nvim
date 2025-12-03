-- lua/kickstart/plugin/lspConfig.lua
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'saghen/blink.cmp',
  },
  config = function()
    local lspconfig = require 'lspconfig'
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- Load all LSP server configs from modular files
    local servers = {
      lua_ls = require 'kickstart.lsp.servers.lua_ls',
      pyright = require 'kickstart.lsp.servers.pyright',
      clangd = require 'kickstart.lsp.servers.clangd',
      jdtls = require 'kickstart.lsp.servers.jdtls',
      eslint = require 'kickstart.lsp.servers.eslint',
      html = require 'kickstart.lsp.servers.html',
    }

    -- Ensure Mason installs the servers
    local ensure_installed = vim.tbl_keys(servers)
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    -- Setup Mason LSP config with handlers
    require('mason-lspconfig').setup {
      ensure_installed = {},
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          lspconfig[server_name].setup(server)
        end,
      },
    }

    -- Put your common LSP behavior here (attach function, diagnostics, highlights, keymaps)
    require('kickstart.lsp.servers.common').setup()
  end,
}
