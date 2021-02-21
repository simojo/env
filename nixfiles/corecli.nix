# core CLI environment
{ config, lib, pkgs, ... }:
{
  console = {
    colors = [
      "4E5173"
      "F7768E"
      "9ECE6A"
      "E0AF68"
      "7AA2F7"
      "9A7ECC"
      "4ABAAF"
      "ACB0D0"
      "000000"
      "F7768E"
      "9ECE6A"
      "E0AF68"
      "7AA2F7"
      "9A7ECC"
      "4ABAAF"
      "ACB0D0"
    ];
    earlySetup = true;
  };
  environment = {
    systemPackages = [
      (with import <nixpkgs> {};
      vim_configurable.customize {
        name = "vim";
        vimrcConfig = {
          customRC = builtins.readFile ../dotfiles/vimrc;
        };
      })
      pkgs.acpi
      pkgs.age
      pkgs.atop
      pkgs.bash
      pkgs.bashCompletion
      pkgs.bashInteractive
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
      pkgs.hdparm
      pkgs.jq
      pkgs.killall
      pkgs.less
      pkgs.lm_sensors
      pkgs.ncdu
      pkgs.netcat
      pkgs.nix
      pkgs.nmap
      pkgs.objconv
      pkgs.openssh
      pkgs.openvpn
      pkgs.pandoc
      pkgs.pass
      pkgs.parted
      pkgs.pinentry
      pkgs.ripgrep
      pkgs.rsync
      pkgs.sd
      pkgs.tldr
      pkgs.tokei
      pkgs.shellcheck
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
    etc."bashrc.local".text = builtins.readFile ../dotfiles/bashrc;
    etc."gitconfig".text = builtins.readFile ../dotfiles/gitconfig;
    etc."htoprc".text = builtins.readFile ../dotfiles/htoprc;
    etc."tmux.conf".text = builtins.readFile ../dotfiles/tmuxconf;
  };

  programs = {
    ssh = {
      startAgent = true;
    };
    gnupg = {
      agent= {
        enable = true;
        pinentryFlavor = "curses";
      };
    };
  };
}
