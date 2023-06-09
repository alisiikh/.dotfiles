local nmap = require('helpers').nmap
local map = require('helpers').map

local telescope_builtin = require('telescope.builtin')
local lsp_group = vim.api.nvim_create_augroup('lsp', { clear = true })
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

local function attach_lsp(client, bufnr)
  nmap('<leader>cr', vim.lsp.buf.rename, { desc = 'lsp: [r]ename' })
  -- nmap('<leader>cr', '<cmd>Lspsaga rename ++project<cr>', { desc = 'lsp: [r]ename' })

  nmap('<leader>ca', vim.lsp.buf.code_action, { desc = 'lsp: [c]ode [a]ction' })
  nmap('<leader>cf', vim.lsp.buf.format, { desc = 'lsp: [c]ode [f]ormat' })
  nmap('<leader>co', '<cmd>Lspsaga outline<cr>', { desc = 'lsp: [c]ode [o]utline' })

  nmap('gd', telescope_builtin.lsp_definitions, { desc = 'lsp: [g]oto [d]efinition' })
  nmap('gr', telescope_builtin.lsp_references, { desc = 'lsp: [g]oto [r]eferences' })
  nmap('gI', vim.lsp.buf.implementation, { desc = 'lsp: [g]oto [i]mplementation' })

  nmap('gd', '<cmd>Lspsaga goto_definition<cr>', { desc = 'lsp: [g]oto [d]efinition' })
  nmap('gp', '<cmd>Lspsaga peek_type_definition<cr>', { desc = 'lsp: [p]eek type definition' })

  -- nmap('gt', vim.lsp.buf.type_definition, { desc = 'lsp: [g]oto [t]ype definition' })
  nmap('gt', '<cmd>Lspsaga goto_type_definition<cr>', { desc = 'lsp: goto [t]ype definition' })


  nmap('gD', vim.lsp.buf.declaration, { desc = 'lsp: [g]oto [d]eclaration' })
  map('i', '<C-h>', vim.lsp.buf.signature_help, { desc = 'lsp: signature [h]elp' })

  nmap('<leader>ws', telescope_builtin.lsp_document_symbols, { desc = 'lsp: [d]ocument [s]ymbols' })
  nmap('<leader>wS', telescope_builtin.lsp_dynamic_workspace_symbols, { desc = 'lsp: [w]orkspace [s]ymbols' })
  -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = '[w]orkspace [a]dd folder'})
  -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc= '[w]orkspace [r]emove folder'})
  -- nmap('<leader>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, '[w]orkspace [l]ist folders')

  -- See `:help K` for why this keymap
  -- nmap('Q', vim.lsp.buf.hover, { desc = 'lsp: hover doc' })
  nmap('Q', '<cmd>Lspsaga hover_doc<CR>', { desc = 'lsp: hover doc' })
  nmap('K', vim.lsp.buf.signature_help, { desc = 'lsp: signature doc' })


  local caps = client.server_capabilities
  if caps.documentFormattingProvider then
    local function fmt_code()
      vim.lsp.buf.format({ bufnr = bufnr })
    end

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', fmt_code, { desc = 'lsp: format code' })
    -- Format code before save :w
    vim.api.nvim_create_autocmd('BufWritePre', {
      callback = fmt_code,
      buffer = bufnr,
      group = lsp_group,
    })
  end

  if caps.documentHighlightProvider then
    vim.api.nvim_create_autocmd('CursorHold', {
      callback = vim.lsp.buf.document_highlight,
      buffer = bufnr,
      group = lsp_group,
    })
  end

  if caps.referencesProvider then
    vim.api.nvim_create_autocmd('CursorMoved', {
      callback = vim.lsp.buf.clear_references,
      buffer = bufnr,
      group = lsp_group,
    })
  end

  if caps.codeLensProvider then
    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
      callback = vim.lsp.codelens.refresh,
      buffer = bufnr,
      group = lsp_group,
    })
  end

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'dap-repl' },
    callback = function() require('dap.ext.autocompl').attach(bufnr) end,
    group = lsp_group,
  })
end


local servers = {
  dockerls = {},
  terraformls = {},
  bashls = {},
  yamlls = {
    settings = {
      yaml = {
        keyOrdering = false -- disable alphabetic ordering of keys
      }
    }
  },
  rnix = {},
  rust_analyzer = {
    cargo = {
      allFeatures = true,
    },
    checkOnSave = {
      command = 'clippy',
    },
  },
  gopls = {
    settings = {
      experimentalWorkspaceModule = false,
      gopls = {
        -- setup inlay hints
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  },
  tsserver = {
    settings = {
      javascript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = 'literals', -- 'none' | 'literals' | 'all';
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = false,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        },
      },
      typescript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = 'literals', -- 'none' | 'literals' | 'all';
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = false,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        },
      },
    },
  },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      hint = {
        enable = false, -- for some reason ignored by inlay-hints plugin
      },
    },
  },
}


local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})
mason_lspconfig.setup_handlers({
  function(server_name)
    require('lspconfig')[server_name].setup({
      capabilities = capabilities,
      on_attach = attach_lsp,
      settings = servers[server_name],
    })
  end,
})

-- Languages are at ${workspaceDir}/lua/language folder
require('language.js').setup()
require('language.lua').setup()
require('language.go').setup()
require('language.scala').setup(capabilities, attach_lsp)
require('language.rust').setup(capabilities, attach_lsp)
