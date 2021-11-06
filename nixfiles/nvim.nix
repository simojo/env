# neovim configuration
{ config, lib, pkgs, ... }:
{
  programs.neovim.configure = {
    customRC = ''
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
    '';
  };
}
