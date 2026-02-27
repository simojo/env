-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--   ___     __     _    _   _ (_)  ___ ___  
-- /' _ `\ /'__`\ /'_`\ ( ) ( )| |/' _ ` _ `\
-- | ( ) |(  ___/( (_) )| \_/ || || ( ) ( ) |
-- (_) (_)`\____)`\___/'`\___/'(_)(_) (_) (_)
--
--                 config file
--         (c) 2026, Simon J. Jones
--
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-- %%%%%%%%%%%%%%%%%%
-- settings & options
-- %%%%%%%%%%%%%%%%%%
local opt = vim.opt

-- Security & Backups
opt.swapfile = false
opt.backup = false
opt.modeline = false

-- Set working dir to current file
vim.cmd("cd %:p:h")

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.smartcase = true
opt.infercase = true
opt.ignorecase = true

-- UI & Display
opt.cursorline = true
opt.number = true
opt.scrolloff = 6
opt.list = true
opt.listchars = { tab = "▸ ", trail = "␣", extends = "»", precedes = "«", nbsp = "•" }
opt.signcolumn = "yes"
opt.termguicolors = true
opt.background = "dark"

-- Manual Statusline
opt.statusline = '%f'
    .. '%( %{FugitiveHead()}%)'
    .. '%( %R%)'
    .. '%( %M%)'
    .. '%='
    .. '%<'
    .. '%( %{&filetype}%)'
    .. '%( %{&encoding}%)'
    .. '%( %l:%c%)'
    .. '%( %p%)'
opt.laststatus = 2
opt.hidden = true
opt.ruler = false
opt.rulerformat = "%6(%=%l%)"

-- Indentation
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.autoindent = true
opt.smartindent = true
opt.copyindent = true
opt.shiftround = true
opt.smarttab = true

-- Globals
vim.g.markdown_recommended_style = 0
vim.g.mapleader = ';'
vim.mapleader = ';'

-- %%%%%%%%%%%%%%%%%%%%%%%%
-- autocommands & filetypes
-- %%%%%%%%%%%%%%%%%%%%%%%%
local user_group = vim.api.nvim_create_augroup('UserEvent', { clear = true })

-- Return to last edit position
vim.api.nvim_create_autocmd('BufReadPost', {
  group = user_group,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    local is_commit = vim.bo[args.buf].filetype == 'commit'
    if mark[1] > 0 and mark[1] <= line_count and not is_commit then
      vim.cmd('normal! g`\"')
    end
  end,
})

-- Markdown / Typst settings
vim.api.nvim_create_autocmd('BufEnter', {
  group = user_group,
  pattern = { '*.md', '*.qmd', '*.typ' },
  callback = function()
    opt.spell = true
    opt.colorcolumn = "81"
    opt.textwidth = 80
  end,
})

-- Custom Filetypes
vim.filetype.add({
  extension = {
    pio = 'pioasm',
    launch = 'xml',
  },
})

-- %%%%%%%%%%%
-- keybindings
-- %%%%%%%%%%%
local map = vim.keymap.set

-- Folding
map('n', 'sf', 'za', {})
map('n', 'si', 'zMzv', {})
map('n', 'sj', 'zj', {})
map('n', 'sk', 'zk', {})
map('n', 'sl', 'zM', {})
map('n', 'sL', 'zR', {})

-- Windows, Splits, and Buffers
map('n', '<Leader>wv', '<C-w>v', { silent = true })
map('n', '<Leader>ws', '<C-w>s', { silent = true })
map('n', '<Leader>wc', '<C-w>c', { silent = true })
map('n', '<Leader>ww', '<C-w><C-w>', { silent = true })
map('n', 'g;', ':bn<CR>', { silent = true })
map('n', 'gj', ':bp<CR>', { silent = true })
map('n', 'h', 'gT', { silent = true })
map('n', 'l', 'gt', { silent = true })

-- Scrolling
map('n', 'J', ':set scroll=2<CR><C-d>', { silent = true })
map('n', 'K', ':set scroll=2<CR><C-u>', { silent = true })

-- Movements & Indentation (Visual)
map('v', '<C-j>', "zR:m '>+1<CR>gv=gv")
map('v', '<C-k>', "zR:m '<-2<CR>gv=gv")
map('v', '>', '>gv', { remap = false })
map('v', '<', '<gv', { remap = false })

-- Incremental search, highlight without jumping
map('n', '*', ':keepjumps normal! mi*`i<CR>:delmarks i<CR>', { remap = false, silent = true })

-- %%%%%%%%%%%%%%%%%%%%%%%%%%
-- plugin manager (lazy.nvim)
-- %%%%%%%%%%%%%%%%%%%%%%%%%%
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- UI & Colorschemes
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
      require('gruvbox').setup {
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = false,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        palette_overrides = {
          dark0 = "#000000",
          dark0_hard = "#000000",
        },
        inverse = false,
        contrast = "hard",
        overrides = {
          Search = { bg = "#665c54" },
          IncSearch = { bg = "#665c54" },
          SignColumn = { bg = "#000000" },
          CursorLine = { bg = "#000000" },
          CursorLineNr = { bg = "#000000" },
          TabLine = { bg = "#000000" },
          StatusLine = { bg = "#000000" },
          StatusLineNC = { bg = "#000000" },
          Pmenu = { bg = "#000000" },
          Pmenu = { bg = "#000000" },
          PmenuSbar = { bg = "#000000" },
          PmenuThumb = { bg = "#000000" },
          TabLine = { bg = "#000000" },
          TabLineSel = { bg = "#000000" },
          TabLineFill = { bg = "#000000" },
        },
      }
      vim.cmd('colorscheme gruvbox')
    end
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup {
        color_overrides = { mocha = { base = "#000000", mantle = "#000000", crust = "#000000" } }
      }
    end
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup {
        ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "rust", "nix", "html", "css", "javascript", "svelte", "python", "julia", "pioasm", "cmake" },
        highlight = {
          enable = true,
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            return ok and stats and stats.size > max_filesize or lang == "json"
          end
        }
      }
    end
  },

  -- Movement & Editing Utilities
  {
    'smoka7/hop.nvim',
    config = function()
      require('hop').setup { keys = 'etovxqpdgfblzhckisuran' }
      vim.keymap.set("n", "<Leader>hc", ":HopChar1<CR>")
      vim.keymap.set("n", "<Leader>hw", ":HopWord<CR>")
      vim.keymap.set("n", "<Leader>hl", ":HopLineStart<CR>")
      vim.keymap.set("n", "<Leader>hk", ":HopLineStartBC<CR>")
      vim.keymap.set("n", "<Leader>hj", ":HopLineStartAC<CR>")
      vim.keymap.set("n", "<Leader>h/", ":HopPattern<CR>")
      vim.keymap.set("n", "<Leader>hp", ":HopPasteChar1<CR>")
      vim.keymap.set("n", "<Leader>hy", ":HopYankChar1<CR>")
      vim.cmd("highlight! link HopNextKey2 HopNextKey1")
    end
  },
  {
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup { default_mappings = false, signs = true, mappings = { set = "m", delete_line = "dm" } }
      vim.cmd("highlight! link SignColumn Normal")
    end
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    config = function()
      require("ibl").setup { indent = { char = "▏" }, scope = { show_start = false, show_end = false } }
    end
  },
  { 'kylechui/nvim-surround', config = true },
  {
    'numtostr/comment.nvim',
    config = function()
      require('Comment').setup({ sticky = true })
      vim.keymap.set("n", "<Leader>i", "gcc", { silent = true, remap = true })
      vim.keymap.set("v", "<Leader>i", "gb", { silent = true, remap = true })
    end
  },
  {
    'skosulor/nibbler',
    config = function()
      require('nibbler').setup({ display_enabled = true })
      vim.keymap.set("n", "<Leader>nh", ":NibblerToHex<CR>")
      vim.keymap.set("n", "<Leader>nb", ":NibblerToBin<CR>")
      vim.keymap.set("n", "<Leader>nd", ":NibblerToDec<CR>")
      vim.keymap.set("n", "<Leader>nt", ":NibblerToggle<CR>")
    end
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require("telescope.builtin")
      local function is_git_repo()
        vim.fn.system("git rev-parse --is-inside-work-tree")
        return vim.v.shell_error == 0
      end
      local function get_git_root()
        local dot_git_path = vim.fn.finddir(".git", ".;")
        return vim.fn.fnamemodify(dot_git_path, ":h")
      end

      vim.keymap.set("n", "<Leader><Tab>", function()
        builtin.live_grep(is_git_repo() and { cwd = get_git_root() } or {})
      end)
      vim.keymap.set("n", "<Tab>", function()
        builtin.find_files(is_git_repo() and { cwd = get_git_root() } or {})
      end)
    end
  },

  -- Miscellaneous Tools
  'tpope/vim-fugitive',
  'gpanders/editorconfig.nvim',
  'godlygeek/tabular',
  {
    "evanleck/vim-svelte",
    init = function()
      vim.g.svelte_indent_script = 0
      vim.g.svelte_indent_style = 0
    end
  },

  -- LSP, Mason, & Autocompletion Stack
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
    },
    config = function()
      -- 1. Setup Autocompletion (Cmp)
      local cmp = require('cmp')
      vim.opt.completeopt = { "menu", "menuone" }
      vim.diagnostic.config({
        underline = {
          severity = { min = vim.diagnostic.severity.ERROR },
        },
      })

      cmp.setup({
        snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end },
        mapping = {
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<Tab>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
        },
        sources = cmp.config.sources({ { name = 'nvim_lsp' }, { name = 'vsnip' } }, { { name = 'buffer' } }),
      })

      cmp.setup.cmdline('/', { sources = { { name = 'buffer' } } })
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
      })

      -- 2. Define standard keymaps for when an LSP attaches
      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set('n', '<Leader>gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', '<Leader>gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<Leader>d', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '<Leader>K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<Leader>gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<Leader><C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<Leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
        vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<Leader>f', function() vim.lsp.buf.format { async = true } end, opts)
      end

      -- 3. Setup Mason & Handlers
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = vim.lsp.config

      -- Idea on how to set up servers from https://github.com/mason-org/mason-lspconfig.nvim/issues/565#issuecomment-2926671274
      local servers = {
        tinymist = { exportPdf = "onSave", outputPath = "$root/pdfs/$dir/$name" },
        arduino_language_server = {
          cmd = { "arduino-language-server --cli-config ./arduino-cli.yaml" }
        },
        julials = {},
        svelte = {},
        rust_analyzer = {},
        cmake = {},
        pylsp = {
          pylsp = {
            plugins = {
              ruff = {
                enabled = false, extendSelect = { "I" }
              },
              pycodestyle = {
                enabled = false, ignore = { "E302", "E501", "W503", "E261" }
              },
              pep8 = {
                enabled = false, ignore = { "E711" }
              },
            }
          }
        },
        clangd = {
          single_file_support = false,
          -- FIXME: is this necessary given the default configs? root_dir = lspconfig.util.root_pattern(".git", "compile_commands.json")
        },
        lua_ls = {},
        vimls = {},
      }

      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_enable = false
      });

      for _name, _settings in pairs(servers) do
        vim.lsp.config(_name, {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = _settings
        })
        vim.lsp.enable(_name)
      end
    end
  }
})
