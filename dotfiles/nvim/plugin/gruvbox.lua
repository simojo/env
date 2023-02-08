-- setting gruvbox settings last
require('gruvbox').setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = false,
  strikethrough = true,
  palette_overrides = {
    dark0 = "#000000",
    dark0_hard = "#000000",
  },
  inverse = false,
  contrast = "hard",
  overrides = {
    SignColumn = {bg = "#000000"},
    CursorLine = {bg = "#000000"},
    CursorLineNr = {bg = "#000000"},
    TabLine = {bg = "#000000"},
    StatusLine = {bg = "#000000"},
    StatusLineNC = {bg = "#000000"},
    Pmenu = {bg = "#000000"},
    PmenuSel = {bg = "#000000"},
    PmenuSbar = {bg = "#000000"},
    PmenuThumb = {bg = "#000000"},
    TabLine = {bg = "#000000"},
    TabLineSel = {bg = "#000000"},
    TabLineFill = {bg = "#000000"},
  },
})
vim.cmd('colorscheme gruvbox')
