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
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      ./coregui.nix
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [ "elevator=none" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-partuuid";

  fileSystems."/" =
    { device = "zpuddle/root";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "zpuddle/nix";
      fsType = "zfs";
    };

  fileSystems."/_projects" =
    { device = "zpuddle/projects";
      fsType = "zfs";
    };

  fileSystems."/_scratch" =
    { device = "zpuddle/scratch";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5DF7-6823";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/85864a8b-8282-4874-b846-f9e61767a05b"; }
    ];

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostId = "fa54f2d0";
    useDHCP = false;
    interfaces = {
      wlp2s0 = {
        useDHCP = true;
      };
    };
    networkmanager.enable = true;
  };

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
      pkgs.ncdu
      pkgs.nix
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

  location = {
    # https://www.latlong.net/
    latitude = 41.646099;
    longitude = -80.147148;
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
      challengeResponseAuthentication = false;
      permitRootLogin = "prohibit-password";
      ports = [55000];
    };
  };

  time.timeZone = "America/New_York";

  users = {
    mutableUsers = true;
    users = {
      simon = {
        isNormalUser = true;
        home = "/home/simon" ;
        extraGroups = [ "wheel" "audio" ];
      };
    };
  };

  system.stateVersion = "20.03";

}

