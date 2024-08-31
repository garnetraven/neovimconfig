local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- Mason setup
require('mason').setup({})

-- Mason LSP setup
require('mason-lspconfig').setup({
  ensure_installed = {'tsserver', 'lua_ls', 'clangd', 'cssls', 'html', 'jdtls', 'pyright'},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})

-- Create a function to configure jdtls separately
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

-- Call the function to setup jdtls
setup_jdtls()
