-- various reasons for disabling these, security and otherwise;
vim.o.swapfile = false
vim.o.backup = false

-- set working dir
vim.cmd("cd %:p:h")

-- modelines are apparently an arbitrary code execution vector, so disable;
vim.o.modeline = false

-- search related settings dragged with me forever; some may be defaults;
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.smartcase = true
vim.o.infercase = true
vim.o.ignorecase = true

-- line number related settings
vim.o.cursorline = true
vim.o.number = true

-- indentation related settings dragged with me forever; some may be defaults;
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.copyindent = true
vim.o.shiftround = true
vim.o.smarttab = true

-- scrollahead for better context;
vim.o.scrolloff = 6

-- statuslines mostly waste vertical space, so show sparingly;
-- use Ctrl+G to get bearings if needed;
vim.o.statusline = '%f'
.. '%( %{FugitiveHead()}%)'
.. '%( %R%)'
.. '%( %M%)'
.. '%='
.. '%<'
.. '%( %{&filetype}%)'
.. '%( %{&encoding}%)'
.. '%( %l:%c%)'
.. '%( %p%)'
vim.o.laststatus = 2
vim.o.hidden = true
vim.o.ruler = false
vim.o.rulerformat = "%6(%=%l%)"

-- for colorscheming
vim.o.background = "dark"

-- keybinds leaderkey, mostly used by plugins;
vim.mapleader = ';'
vim.g.mapleader = ';'

-- keybinds pertaining to folding;
vim.api.nvim_set_keymap('n', 'sf', 'za', {})
vim.api.nvim_set_keymap('n', 'si', 'zMzv', {})
vim.api.nvim_set_keymap('n', 'sj', 'zj', {})
vim.api.nvim_set_keymap('n', 'sk', 'zk', {})
vim.api.nvim_set_keymap('n', 'sl', 'zM', {})
vim.api.nvim_set_keymap('n', 'sL', 'zR', {})

-- keybinds pertaining to splits, buffers, and windows;
vim.api.nvim_set_keymap('n', '<Leader>wv', '<c-w>v', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>ws', '<c-w>s', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>wc', '<c-w>c', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>ww', '<c-w><c-w>', { silent = true })
vim.api.nvim_set_keymap('n', 'g;', ':bn<cr>', { silent = true })
vim.api.nvim_set_keymap('n', 'gj', ':bp<cr>', { silent = true })
vim.api.nvim_set_keymap('n', 'h', 'gT', { silent = true })
vim.api.nvim_set_keymap('n', 'l', 'gt', { silent = true })

-- keybinds pertaining to scrolling;
vim.api.nvim_set_keymap('n', 'J', ':set scroll=2<cr><c-d>', { silent = true })
vim.api.nvim_set_keymap('n', 'K', ':set scroll=2<cr><c-u>', { silent = true })

-- keybinds pertaining to movements;
vim.api.nvim_set_keymap('n', '<C-j>', 'zRddp==', {})
vim.api.nvim_set_keymap('n', '<C-k>', 'zRddkP==', {})
vim.api.nvim_set_keymap('v', '<C-j>', 'zR:m\'>+1<CR>gv=gv', {})
vim.api.nvim_set_keymap('v', '<C-k>', 'zR:m\'<-2<CR>gv=gv', {})
vim.api.nvim_set_keymap('v', '>', '><cr>gv', { noremap = true })
vim.api.nvim_set_keymap('v', '<', '<<cr>gv', { noremap = true })

-- plugins and associated configs via packer.nvim; autoinstalls as necessary;
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end
return require('packer').startup(function(use)
  -- packer manages itself;
  use 'wbthomason/packer.nvim'

  use { 'ellisonleao/gruvbox.nvim' }

  -- quickly jump around the visible buffer;
  use {
    'phaazon/hop.nvim',
    branch = 'v1',
    config = function()
      require('hop').setup { keys = 'etovxqpdgfblzhckisuran' }
      vim.api.nvim_set_keymap("n", "<Leader>l", "<cmd>lua require'hop'.hint_words()<cr>", {})
      vim.api.nvim_set_keymap("n", "<Leader>k", "<cmd>lua require'hop'.hint_lines()<cr>", {})
      vim.api.nvim_set_keymap("n", "<Leader>j", "<cmd>lua require'hop'.hint_lines_skip_whitespace()<cr>", {})
      vim.cmd("highlight! link HopNextKey2 HopNextKey1") -- make second character more visible
    end
  }

  -- show marks in sign column;
  use {
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup {
        default_mappings = false,
        signs = true,
        mappings = {
          set = "m",
          delete_line = "dm",
        }
      }
      vim.o.signcolumn = "yes"
      vim.cmd("highlight! link SignColumn Normal")
    end
  }

  -- fuzzy searching to open files;
  use {
    'camspiers/snap',
    config = function()
      local snap = require'snap'
      snap.maps {
        -- primary way to open and jump between files; relies on ripgrep;
        -- previews disabled in case of screen recording to not leak secrets;
        {"<Tab>", snap.config.file {producer = "ripgrep.file", preview = false}},
      }
    end
  }

  -- indentation guides
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup {
      }
    end
  }

  -- fuzzy finder for files/git/buffers/etc
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- comment-toggling;
  use {
    'numtostr/comment.nvim',
    config = function()
      require('Comment').setup({
        sticky = true,
      })
      vim.api.nvim_set_keymap("n", "<Leader>i", "gcc", { silent = true })
      vim.api.nvim_set_keymap("v", "<Leader>i", "gb", { silent = true })
    end
  }

  use "tpope/vim-fugitive"
  use {
    "evanleck/vim-svelte",
    config = function()
      vim.g.svelte_indent_script = 0
      vim.g.svelte_indent_style = 0
    end
  }
  use "gpanders/editorconfig.nvim"

  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require'cmp'
      vim.opt.completeopt = {"menu", "menuone"}
      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
          end,
        },
        mapping = {
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          })
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        }, {
          { name = 'buffer' },
        }),
        completion = {
          completeopt = 'menu,menuone'
        },
      })
      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline('/', {
        sources = {
          { name = 'buffer' }
        }
      })
      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
      -- svelte lsp
      require'lspconfig'.svelte.setup{}
      -- haskell lsp
      require'lspconfig'.hls.setup{}
      -- rust lsp
      require'lspconfig'.rust_analyzer.setup{}
    end
  }




  -- this must be last
  if packer_bootstrap then
    require('packer').sync()
  end
end)
