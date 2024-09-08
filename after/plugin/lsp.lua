local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})

-- Mason LSP setup
require('mason-lspconfig').setup({
  ensure_installed = {'ts_ls', 'lua_ls', 'clangd', 'cssls', 'html', 'jdtls', 'pyright'},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})

-- Configure lua_ls
local function setup_lua_ls()
  local lua_ls = require('lspconfig').lua_ls
  lua_ls.setup({
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.split(package.path, ';'),
        },
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false, -- for external libraries
        },
        telemetry = {
          enable = false,
        },
      },
    },
    on_attach = function(client, bufnr)
      lsp_zero.default_keymaps({buffer = bufnr})
    end,
  })
end

-- Configure jdtls 
local function setup_jdtls()
  local jdtls = require('lspconfig').jdtls
  jdtls.setup({
    cmd = {'jdtls'},
    root_dir = function(fname)
      return require('lspconfig').util.root_pattern('pom.xml', 'build.gradle', '.git')(fname)
    end,
    settings = {
      java = {
        eclipse = {
          downloadSources = true,
        },
        configuration = {
          updateBuildConfiguration = 'interactive',
        },
        maven = {
          downloadSources = true,
        },
      },
    },
    on_attach = function(client, bufnr)
      lsp_zero.default_keymaps({buffer = bufnr})
    end,
  })
end

setup_jdtls()
setup_lua_ls()
