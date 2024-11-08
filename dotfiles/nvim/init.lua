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

vim.cmd("let g:markdown_recommended_style = 0")

-- indentation spaces tabs and whitespace nonsense
vim.o.list = true
vim.o.listchars = "tab:▸ ,trail:␣,extends:»,precedes:«,nbsp:•"

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

-- markdown: linewidth guide and spell check
-- https://vi.stackexchange.com/questions/11609/automatically-rewrap-lines-when-writing-markdown-in-vim
vim.cmd("autocmd BufEnter *.md,*.qmd set spell")
vim.cmd("autocmd BufEnter *.md,*.qmd set colorcolumn=81")
vim.cmd("autocmd BufEnter *.md,*.qmd set textwidth=80")

-- pio: set filetype automatically
vim.cmd("autocmd BufEnter *.pio set filetype=pioasm")
--
-- launch: set filetype automatically
vim.cmd("autocmd BufEnter *.launch set filetype=xml")

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

-- incremental search, highlight without jumping
vim.api.nvim_set_keymap('n', '*', ':keepjumps normal! mi*`i<CR>:delmarks i<CR>', { noremap = true, silent = true })

-- plugins and associated configs via packer.nvim; autoinstalls as necessary;
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end
return require('packer').startup(function(use)
  -- packer manages itself;
  use 'wbthomason/packer.nvim'

  -- dark colorscheme (default)
  use { 'ellisonleao/gruvbox.nvim' }
  -- light colorscheme (default)
  use { 'catppuccin/nvim',
    config = function()
      require('catppuccin').setup {
        color_overrides = {
          mocha = {
            base = "#000000",
            mantle = "#000000",
            crust = "#000000",
          },
        }
      }
    end
  }

  use { 'nvim-treesitter/nvim-treesitter',
    run = function()
      -- from treesitter wiki, mitigates packer from breaking on first treesitter install
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    config = function()
      require('nvim-treesitter.configs').setup {
        -- list of parsers to always be installed
        ensure_installed = {
          "c", "cpp", "lua", "vim", "vimdoc", "rust", "nix",
          "html", "css", "javascript", "svelte", "python",
          "julia", "pioasm", "cmake"
        },
        highlight = {
          enable = true,
          disable = { "json" },
          -- disable highlight on large files
          disable = function (lang, buf)
            local max_filesize = 100 * 1024 -- 100KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end
        }
      }
    end
  }

  -- quickly jump around the visible buffer;
  use {
    'smoka7/hop.nvim',
    tag = "*",
    config = function()
      require('hop').setup { keys = 'etovxqpdgfblzhckisuran' }
      vim.api.nvim_set_keymap("n", "<Leader>hc", ":HopChar1<cr>", {}) -- hop to char
      vim.api.nvim_set_keymap("n", "<Leader>hw", ":HopWord<cr>", {}) -- hop to word
      vim.api.nvim_set_keymap("n", "<Leader>hl", ":HopLineStart<cr>", {}) -- hop to line first char
      vim.api.nvim_set_keymap("n", "<Leader>hk", ":HopLineStartBC<cr>", {}) -- hop to line first char before cursor
      vim.api.nvim_set_keymap("n", "<Leader>hj", ":HopLineStartAC<cr>", {}) -- hop to line first char after cursor
      vim.api.nvim_set_keymap("n", "<Leader>h/", ":HopPattern<cr>", {}) -- hop to pattern matches
      vim.api.nvim_set_keymap("n", "<Leader>hp", ":HopPasteChar1<cr>", {}) -- paste among locations with specified character
      vim.api.nvim_set_keymap("n", "<Leader>hy", ":HopYankChar1<cr>", {}) -- paste among locations with specified character
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

  -- indentation guides
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require("ibl").setup {
        indent = { char = "▏" },
        scope = {
          show_start = false,
          show_end = false,
        }
      }
    end,
  }

  -- surrounding selections and editing surrounding characters
  use {
    'kylechui/nvim-surround',
    config = function()
      require("nvim-surround").setup {
      }
    end,
  }

  -- fuzzy finder for files/git/buffers/etc
  use {
    'nvim-telescope/telescope.nvim',
    config = function()
      -- utility function for determining if inside of repo
      local function is_git_repo()
        vim.fn.system("git rev-parse --is-inside-work-tree")

        return vim.v.shell_error == 0
      end
      -- utility function for finding root of git project
      local function get_git_root()
        local dot_git_path = vim.fn.finddir(".git", ".;")
        return vim.fn.fnamemodify(dot_git_path, ":h")
      end
      -- export custom command for grepping project files,
      -- falling back to local directory
      function vim.telescope_grep_project_files()
        local opts = {}
        if is_git_repo() then
          opts = {
            cwd = get_git_root(),
          }
        end
        require("telescope.builtin").live_grep(opts)
      end
      -- export custom command for finding project files,
      -- falling back to local directory
      function vim.telescope_find_project_files()
        local opts = {}
        if is_git_repo() then
          opts = {
            cwd = get_git_root(),
          }
        end
        require("telescope.builtin").find_files(opts)
      end
      -- use custom commands as wrappers to telescope
      vim.api.nvim_set_keymap("n", "<Leader><Tab>", ":lua vim.telescope_grep_project_files()<cr>", {})
      vim.api.nvim_set_keymap("n", "<Tab>", ":lua vim.telescope_find_project_files()<cr>", {})
    end,
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
          ['<c-j>'] = cmp.mapping.select_next_item(),
          ['<c-k>'] = cmp.mapping.select_prev_item(),
          ['<Tab>'] = cmp.mapping.confirm({
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
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', '<Leader>gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', '<Leader>gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', '<Leader>d', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '<Leader>K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<Leader>gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<Leader><C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<Leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<Leader>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })
      local nvim_lsp = require('lspconfig')
      -- typst lsp
      require'lspconfig'.tinymist.setup{}
      -- nix lsp
      require'lspconfig'.nil_ls.setup{}
      -- arduino lsp
      require'lspconfig'.arduino_language_server.setup{}
      -- julia lsp
      require'lspconfig'.julials.setup{}
      -- svelte lsp
      require'lspconfig'.svelte.setup{}
      -- haskell lsp
      require'lspconfig'.hls.setup{}
      -- rust lsp
      require'lspconfig'.rust_analyzer.setup{}
      -- vhdl lsp
      require'lspconfig'.ghdl_ls.setup{}
      -- cmake lsp
      require'lspconfig'.cmake.setup{}
      -- python lsp
      require'lspconfig'.pylsp.setup{
        settings = {
          pylsp = {
            plugins = {
              ruff = {
                enabled = true,
                extendSelect = { "I" },
              },
              pycodestyle = {ignore = { "E302", "E501", "W503" }},
              pep8 = {ignore = { "E711" }},
            }
          }
        }
      }
      -- cpp/c lsp
      require'lspconfig'.clangd.setup{
        single_file_support = false,
        root_dir = nvim_lsp.util.root_pattern(".git", "compile_commands.json")
      }
    end
  }




  -- this must be last
  if packer_bootstrap then
    require('packer').sync()
  end
end)
