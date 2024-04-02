
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
	    -- autocompletion
	    'hrsh7th/nvim-cmp',
	    dependencies = {
	      -- snippet engine & its associated nvim-cmp source
	      {
		'l3mon4d3/luasnip',
		build = (function()
		  -- build step is needed for regex support in snippets
		  -- this step is not supported in many windows environments
		  -- remove the below condition to re-enable on windows
		  if vim.fn.has 'win32' == 1 then
		    return
		  end
		  return 'make install_jsregexp'
		end)(),
	      },
	      'saadparwaiz1/cmp_luasnip',

	      -- adds lsp completion capabilities
	      'hrsh7th/cmp-nvim-lsp',
	      'hrsh7th/cmp-path',

	      -- adds a number of user-friendly snippets
	      'rafamadriz/friendly-snippets',
	    },
	  },
		
	-- useful plugin to show you pending keybinds.
	{ 'folke/which-key.nvim', opts = {} },


	-- fuzzy finder (files, lsp, etc)
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			-- fuzzy finder algorithm which requires local dependencies to be built.
			-- only load if `make` is available. make sure you have the system
			-- requirements installed.
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				-- note: if you are having trouble with this installation,
				--       refer to the readme for telescope-fzf-native for more instructions.
				build = 'make',
				cond = function()
				  return vim.fn.executable 'make' == 1
				end,
			},
		},
	},
    -- enable autotag closing for html and the like
    'windwp/nvim-ts-autotag',
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':tsupdate',
	},

    -- autopair to close brackets and stuff
    {
        'windwp/nvim-autopairs',
        event = 'insertenter',
        opts = {}
    },
    -- language specific stuff
    -- odin colorscheme
    'tetralux/odin.vim',

    -- markdown support
    'ixru/nvim-markdown',

    -- download themes
    "rebelot/kanagawa.nvim",
    
    "neanias/everforest-nvim"
})

-- setup theme
require('everforest').setup({
    background = "soft",
    ui_contrast = "high"
})

-- activate theme
vim.cmd("colorscheme everforest")

-- setup autotag for treesitter
require('nvim-ts-autotag').setup()

-- enable completion

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- [[ configure nvim-cmp ]]
-- see `:help cmp`
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
    completeopt = 'menu,menuone,noinsert,noselect',
  },
  preselect = cmp.PreselectMode.None,
  mapping = cmp.mapping.preset.insert {
    ['<c-n>'] = cmp.mapping.select_next_item(),
    ['<c-p>'] = cmp.mapping.select_prev_item(),
    ['<c-b>'] = cmp.mapping.scroll_docs(-4),
    ['<c-f>'] = cmp.mapping.scroll_docs(4),
    ['<c-space>'] = cmp.mapping.complete {},
    ['<cr>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.replace,
      select = false,
    },
    ['<tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<s-tab>'] = cmp.mapping(function(fallback)
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


-- set highlight on search
vim.o.hlsearch = false

-- make line numbers default
vim.wo.number = true

-- enable mouse mode
vim.o.mouse = 'a'

-- sync clipboard between os and neovim.
--  remove this option if you want your os clipboard to remain independent.
--  see `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- enable break indent
vim.o.breakindent = true

-- save undo history
vim.o.undofile = true

-- case-insensitive searching unless \c or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- we start loading different files now
-- eg for config plugin and keymap
require("plugins/telescope")
require("lsp")
require("keymap")
