require('lazy').setup({
  -- catppuccin theme
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },

  -- icons
  { 'nvim-tree/nvim-web-devicons', opts = {} },

  -- statusline plugin
  'nvim-lualine/lualine.nvim',

  -- tmux integration plugin
  { 'christoomey/vim-tmux-navigator', lazy = false },

  -- required by most plugins
  'nvim-lua/plenary.nvim',

  -- git plugin
  { 'tpope/vim-fugitive', dependencies = { 'tpope/vim-rhubarb' } },

  -- file tree explorer
  'nvim-tree/nvim-tree.lua',

  -- traverse diagnostics in a separate window
  'folke/trouble.nvim',

  -- quick navigation between frequently used files
  {
    'letieu/harpoon-lualine',
    dependencies = {
      {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
      },
    },
  },

  -- undo tree history
  'mbbill/undotree',
  -- forever undo
  {
    'kevinhwang91/nvim-fundo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
      require('fundo').install()
    end,
  },

  -- autocompletion (cmp), integration with lsp, ai, snippets, etc.
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/vim-vsnip',
      'hrsh7th/vim-vsnip-integ',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      -- Beautiful nerd font icons in cmp
      'onsails/lspkind-nvim',
    },
  },

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', opts = { ui = { border = 'rounded' } } },
      { 'williamboman/mason-lspconfig.nvim' },
      {
        'jay-babu/mason-null-ls.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = { 'nvimtools/none-ls.nvim' },
      },
      {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = { 'mfussenegger/nvim-dap' },
      },
    },
  },

  -- Status updates for LSP showing on the right
  { 'j-hui/fidget.nvim', opts = {} },

  -- additional lua configuration, for lua development
  'folke/neodev.nvim',

  -- Scala metals
  'scalameta/nvim-metals',
  -- my ZIO helper plugin
  { 'alisiikh/nvim-scala-zio-quickfix', dev = true, opts = {} },
  -- cowboy
  { 'alisiikh/nvim-cowboy', dev = true, opts = {} },

  -- rust support
  { 'mrcjkb/rustaceanvim', version = '^4', ft = { 'rust' } },
  { 'saecki/crates.nvim', opts = {}, ft = { 'rust', 'toml' } },

  -- debugging
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      { 'theHamsta/nvim-dap-virtual-text' },
      { 'rcarriga/nvim-dap-ui' },
      { 'jbyuki/one-small-step-for-vimkind' }, -- debug lua
      { 'leoluz/nvim-dap-go' }, -- debug go
      { 'mxsdev/nvim-dap-vscode-js' }, -- debug js
    },
  },

  -- fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      {
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        -- Only load if `make` is available. Make sure you have the system
        -- requirements installed.
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
      'nvim-telescope/telescope-frecency.nvim',
      'nvim-telescope/telescope-dap.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
    },
  },

  -- treesitter: highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
      'nvim-treesitter/playground',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update({ with_sync = true }))
    end,
  },

  -- unofficial Codeium plugin, interactive AI autocomplete
  {
    'Exafunction/codeium.nvim',
    event = 'InsertEnter',
    opts = {},
  },

  -- detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- multi-cursor selection ctrl+up/down - to add cursor, ctrl+n - select next word, shift-arrow - per char
  'mg979/vim-visual-multi',

  -- auto add closing bracket or closing quote
  { 'windwp/nvim-autopairs', opts = {} },

  -- surround text objects, ys - surround, ds - delete around, cs - change around
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    opts = {},
  },

  -- smart join lines in blocks
  'Wansmer/treesj',

  -- useful plugin to show you pending keybinds.
  'folke/which-key.nvim',

  -- adds git releated signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',

  -- add indentation function/class/etc context lines
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },

  -- comment lines and blocks with 'gcc', 'gbc'
  { 'numToStr/Comment.nvim', opts = {} },

  -- comments highlighting and navigation
  { 'folke/todo-comments.nvim' },

  -- nice notifications in vim
  {
    'rcarriga/nvim-notify',
    config = function()
      -- globally setup nvim-notify to be nvim notifications provider
      vim.notify = require('notify')
    end,
  },

  -- neotest framework for running tests
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-neotest/neotest-plenary',
      'nvim-neotest/neotest-go',
      'stevanmilic/neotest-scala',
    },
  },
}, {
  lockfile = vim.fn.stdpath('data') .. '/lazy/lazy-lock.json',
  dev = {
    path = '~/Develop/nvim-plugins',
  },
  ui = {
    border = 'rounded',
  },
})
