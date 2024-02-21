
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- install plugins
-- Config is done in other files
require('lazy').setup({
	'neovim/nvim-lspconfig',
	

	{
	    -- Autocompletion
	    'hrsh7th/nvim-cmp',
	    dependencies = {
	      -- Snippet Engine & its associated nvim-cmp source
	      {
		'L3MON4D3/LuaSnip',
		build = (function()
		  -- Build Step is needed for regex support in snippets
		  -- This step is not supported in many windows environments
		  -- Remove the below condition to re-enable on windows
		  if vim.fn.has 'win32' == 1 then
		    return
		  end
		  return 'make install_jsregexp'
		end)(),
	      },
	      'saadparwaiz1/cmp_luasnip',

	      -- Adds LSP completion capabilities
	      'hrsh7th/cmp-nvim-lsp',
	      'hrsh7th/cmp-path',

	      -- Adds a number of user-friendly snippets
	      'rafamadriz/friendly-snippets',
	    },
	  },

	-- Autocompletion
	'hrsh7th/nvim-cmp',

    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
          {
            'L3MON4D3/LuaSnip',
            build = (function()
              -- Build Step is needed for regex support in snippets
              -- This step is not supported in many windows environments
              -- Remove the below condition to re-enable on windows
              if vim.fn.has 'win32' == 1 then
                return
              end
              return 'make install_jsregexp'
            end)(),
          },
          'saadparwaiz1/cmp_luasnip',

          -- Adds LSP completion capabilities
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-path',

          -- Adds a number of user-friendly snippets
          'rafamadriz/friendly-snippets',
        },
	
	-- Useful plugin to show you pending keybinds.
	{ 'folke/which-key.nvim', opts = {} },


	-- Fuzzy Finder (files, lsp, etc)
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			-- Fuzzy Finder Algorithm which requires local dependencies to be built.
			-- Only load if `make` is available. Make sure you have the system
			-- requirements installed.
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				-- NOTE: If you are having trouble with this installation,
				--       refer to the README for telescope-fzf-native for more instructions.
				build = 'make',
				cond = function()
				  return vim.fn.executable 'make' == 1
				end,
			},
		},
	},
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
	},

    -- download theme
    "rebelot/kanagawa.nvim"    
})

-- Activate theme
vim.cmd("colorscheme kanagawa")

-- Enable completion

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

-- some general tab and visual settings
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.relativenumber = true
vim.o.smarttab = true
vim.o.timeoutlen = 150 -- shorten, more convenient for which key


-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- We start loading different files now
-- Eg for config plugin and keymap
require("plugins/telescope")
require("lsp")
require("keymap")
