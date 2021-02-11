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
      pkgs.bat
      pkgs.curl
      pkgs.docker
      pkgs.eidolon
      pkgs.entr
      pkgs.exa
      pkgs.fd
      pkgs.file
      pkgs.fzf
      pkgs.git
      pkgs.gnugrep
      pkgs.gnumake
      pkgs.gnupg
      pkgs.gnused
      pkgs.gnutar
      pkgs.htop
      pkgs.jq
      pkgs.killall
      pkgs.less
      pkgs.ncdu
      pkgs.netcat
      pkgs.nix
      pkgs.nmap
      pkgs.objconv
      pkgs.openvpn
      pkgs.pandoc
      pkgs.pinentry
      pkgs.ripgrep
      pkgs.rsync
      pkgs.sd
      pkgs.tig
      pkgs.tldr
      pkgs.tmux
      pkgs.tree
      pkgs.unstable.elixir
      pkgs.unstable.jdk
      pkgs.unstable.nim
      pkgs.unstable.nodejs
      pkgs.unzip
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
