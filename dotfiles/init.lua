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

-- highlighting; leaving as vimscript until I have time to migrate to lua
vim.cmd [[
" setup
syntax enable
set background=dark
if exists("syntax_on")
  syntax reset
endif
set synmaxcol=0
hi clear

"%%%%% Vim UI %%%%%
hi! ColorColumn                    ctermfg=none  ctermbg=none  cterm=none
hi! Conceal                        ctermfg=8     ctermbg=none  cterm=none
hi! Cursor                         ctermfg=none  ctermbg=none  cterm=none
hi! CursorLine                     ctermfg=none  ctermbg=none  cterm=none
hi! CursorLineNr                   ctermfg=7     ctermbg=none  cterm=none
hi! DiffAdd                        ctermfg=2     ctermbg=none  cterm=none
hi! DiffChange                     ctermfg=3     ctermbg=none  cterm=none
hi! DiffDelete                     ctermfg=1     ctermbg=none  cterm=none
hi! DiffText                       ctermfg=8     ctermbg=none  cterm=bold
hi! Directory                      ctermfg=12    ctermbg=none  cterm=none
hi! Folded                         ctermfg=7     ctermbg=none  cterm=none
hi! LineNr                         ctermfg=8     ctermbg=none  cterm=none
hi! MatchParen                     ctermfg=7     ctermbg=none  cterm=underline
hi! NonText                        ctermfg=8     ctermbg=none  cterm=none
hi! Pmenu                          ctermfg=8     ctermbg=none  cterm=none
hi! PmenuSBar                      ctermfg=none  ctermbg=none  cterm=none
hi! PmenuSel                       ctermfg=15    ctermbg=none  cterm=none
hi! PmenuThumb                     ctermfg=none  ctermbg=none  cterm=none
hi! SpellBad                       ctermfg=1     ctermbg=none  cterm=underline
hi! SpellCap                       ctermfg=1     ctermbg=none  cterm=underline
hi! SpellLocal                     ctermfg=13    ctermbg=none  cterm=underline
hi! SpellRare                      ctermfg=11    ctermbg=none  cterm=underline
hi! StatusLine                     ctermfg=8     ctermbg=none  cterm=none
hi! StatusLineNC                   ctermfg=8     ctermbg=none  cterm=none
hi! TabLine                        ctermfg=8     ctermbg=none  cterm=bold
hi! TabLineSel                     ctermfg=7     ctermbg=none  cterm=bold
hi! Title                          ctermfg=7     ctermbg=none  cterm=bold
hi! User1                          ctermfg=1     ctermbg=none  cterm=none
hi! User2                          ctermfg=4     ctermbg=none  cterm=none
hi! User3                          ctermfg=2     ctermbg=none  cterm=none
hi! User4                          ctermfg=3     ctermbg=none  cterm=none
hi! User5                          ctermfg=5     ctermbg=none  cterm=none
hi! User6                          ctermfg=6     ctermbg=none  cterm=none
hi! User7                          ctermfg=7     ctermbg=none  cterm=none
hi! User8                          ctermfg=8     ctermbg=none  cterm=none
hi! User9                          ctermfg=15    ctermbg=none  cterm=none
hi! VertSplit                      ctermfg=8     ctermbg=none  cterm=none
hi! Visual                         ctermfg=none  ctermbg=none  cterm=reverse
hi! WildMenu                       ctermfg=15    ctermbg=none  cterm=none

hi! link Search                    Visual
hi! link IncSearch                 Visual
hi! link ModeMsg                   NonText
hi! link VisualNOS                 Visual
hi! link SpellBad                  Error
hi! link SpellLocal                Normal
hi! link PmenuSbar                 Pmenu
hi! link PmenuThumb                Pmenu
hi! link ColorColumn               Normal
hi! link SignColumn                Normal
hi! link FoldColumn                Normal
hi! link VertSplit                 StatusLine
hi! link WarningMsg                Error
hi! link SpecialKey                Comment

hi! link CursorColumn              CursorLine
hi! link FoldColumn                SignColumn
hi! link IncSearch                 Visual
hi! link ModeMsg                   MoreMsg
hi! link MoreMsg                   Title
hi! link Question                  MoreMsg
hi! link Search                    Visual
hi! link SignColumn                LineNr
hi! link SpecialKey                NonText
hi! link TabLineFill               StatusLineNC
hi! link WarningMsg                ErrorMsg

"%%%%% Major %%%%%
hi! Normal                         ctermfg=none  ctermbg=none  cterm=none
hi! Comment                        ctermfg=8     ctermbg=none  cterm=none
hi! Constant                       ctermfg=3     ctermbg=none  cterm=none
hi! Identifier                     ctermfg=14    ctermbg=none  cterm=none
hi! Statement                      ctermfg=2     ctermbg=none  cterm=none
hi! PreProc                        ctermfg=5     ctermbg=none  cterm=none
hi! Type                           ctermfg=4     ctermbg=none  cterm=none
hi! Special                        ctermfg=13    ctermbg=none  cterm=none
hi! Underlined                     ctermfg=4     ctermbg=none  cterm=underline
hi! Ignore                         ctermfg=0     ctermbg=none  cterm=none
hi! Error                          ctermfg=1     ctermbg=none  cterm=underline
hi! Todo                           ctermfg=1     ctermbg=none  cterm=bold,underline
hi! link ErrorMsg                  Error

hi! Delimiter                      ctermfg=7     ctermbg=none  cterm=none
hi! String                         ctermfg=10     ctermbg=none  cterm=none
hi! Keyword                        ctermfg=1     ctermbg=none  cterm=none
hi! Function                       ctermfg=4     ctermbg=none  cterm=none
hi! Number                         ctermfg=10     ctermbg=none  cterm=none
hi! link Operator                  Delimiter

"%%%%% ALE %%%%%
hi! ALEWarning                     ctermfg=3 ctermbg=none cterm=none
hi! ALEInfo                        ctermfg=15 ctermbg=none cterm=none
hi! ALEInfoSign                    ctermfg=15 ctermbg=none cterm=none
hi! link ALEWarningSign            ALEWarning
hi! link ALEStyleWarning           ALEWarning
hi! link ALEStyleWarningSign       ALEWarning
hi! link ALEStyleError             ALEWarning

"FIMXE: For Hop.nvim
"%%%%% EasyMotion %%%%%
hi! EasyMotionTarget               ctermfg=1 ctermbg=none cterm=none
hi! EasyMotionTarget2First         ctermfg=15 ctermbg=none cterm=none
hi! EasyMotionTarget2Second        ctermfg=15 ctermbg=none cterm=none
hi! link EasyMotionShade           NonText

"%%%%% Diff %%%%%
hi! link diffAdded                 DiffAdd
hi! link diffRemoved               DiffDelete
hi! link diffFile                  Comment
hi! link diffLine                  Title

"%%%%% Vim help %%%%%
hi! link helpExample               String
hi! link helpHeadline              Title
hi! link helpSectionDelim          Comment
hi! link helpHyperTextEntry        Statement
hi! link helpHyperTextJump         Underlined
hi! link helpURL                   Underlined

"%%%%% Signify %%%%%
hi! link SignifySignAdd            DiffAdd
hi! link SignifySignDelete         DiffDelete
hi! link SignifySignChange         DiffChange
hi! link SignifySignChangeDelete   DiffDelete
]]

-- plugins and associated configs via packer.nvim; autoinstalls as necessary;
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end
return require('packer').startup(function(use)
  -- packer manages itself;
  use 'wbthomason/packer.nvim'

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
