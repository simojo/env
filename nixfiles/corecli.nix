{ config, lib, pkgs, ... }:
let
  dotfiles = {
    vimrc = builtins.readFile /env/dotfiles/vimrc;
    htoprc = builtins.readFile /env/dotfiles/htoprc;
    bashrc = builtins.readFile /env/dotfiles/bashrc;
    gitconfig = builtins.readFile /env/dotfiles/gitconfig;
    tmuxconf = builtins.readFile /env/dotfiles/tmuxconf;
  };
in {
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = [
      (with import <nixpkgs> {};
      vim_configurable.customize {
        name = "vim";
        vimrcConfig = {
          customRC = dotfiles.vimrc;
        };
      })
      pkgs.acpi
      pkgs.age
      pkgs.atop
      pkgs.bash
      pkgs.curl
      pkgs.fzf
      pkgs.git
      pkgs.gnugrep
      pkgs.gnumake
      pkgs.gnupg
      pkgs.gnused
      pkgs.gnutar
      pkgs.htop
      pkgs.killall
      pkgs.ncdu
      pkgs.nix
      pkgs.nodejs
      pkgs.pinentry
      pkgs.ripgrep
      pkgs.rsync
      pkgs.tig
      pkgs.tmux
      pkgs.vim
      pkgs.wpa_supplicant
      pkgs.xclip
      pkgs.zip
      pkgs.zsh
    ];
    etc."bashrc.local".text = dotfiles.bashrc;
    etc."gitconfig".text = dotfiles.gitconfig;
    etc."htoprc".text = dotfiles.htoprc;
    etc."tmux.conf".text = dotfiles.tmuxconf;
  };
}