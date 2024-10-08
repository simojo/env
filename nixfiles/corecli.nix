# core CLI environment
{ config, lib, pkgs, ... }:
{
  console = {
    colors = [
      "000000"
      "F7768E"
      "9ECE6A"
      "E0AF68"
      "7AA2F7"
      "9A7ECC"
      "4ABAAF"
      "ACB0D0"
      "4E5173"
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
          customRC = builtins.readFile /env/dotfiles/vimrc;
        };
      })
      pkgs.acpi
      pkgs.age
      pkgs.atop
      pkgs.bash
      pkgs.bash-completion
      pkgs.bashInteractive
      pkgs.bat
      pkgs.curl
      pkgs.delta
      pkgs.docker
      pkgs.docker-compose
      pkgs.eidolon
      pkgs.elixir
      pkgs.entr
      pkgs.exa
      pkgs.fd
      pkgs.file
      pkgs.fzf
      pkgs.ghc
      pkgs.git
      pkgs.gnugrep
      pkgs.gnumake
      pkgs.gnupg
      pkgs.gnused
      pkgs.gnutar
      pkgs.hdparm
      pkgs.htop
      pkgs.hyperfine
      pkgs.jdk
      pkgs.killall
      pkgs.less
      pkgs.lm_sensors
      pkgs.ncdu
      pkgs.netcat
      pkgs.nil
      pkgs.nim
      pkgs.nix
      pkgs.nix-index
      pkgs.nmap
      pkgs.nodejs
      pkgs.objconv
      pkgs.openssh
      pkgs.openvpn
      pkgs.pandoc
      pkgs.parted
      pkgs.pinentry
      pkgs.qemu_kvm
      pkgs.ripgrep
      pkgs.rsync
      pkgs.ruby
      pkgs.sd
      pkgs.shellcheck
      pkgs.sshfs
      pkgs.tig
      pkgs.tldr
      pkgs.tmux
      pkgs.tokei
      pkgs.tree
      pkgs.unstable.neovim
      pkgs.unzip
      pkgs.vim
      pkgs.wpa_supplicant
      pkgs.xc3sprog
      pkgs.xclip
      pkgs.zip
      pkgs.zsh
    ];
    etc."bashrc.local".text = builtins.readFile /env/dotfiles/bashrc;
    etc."gitconfig".text = builtins.readFile /env/dotfiles/gitconfig;
    etc."htoprc".text = builtins.readFile /env/dotfiles/htoprc;
    etc."tmux.conf".text = builtins.readFile /env/dotfiles/tmuxconf;
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
