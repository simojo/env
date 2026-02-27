/* FIXME

evaluation warning: The option `services.openssh.permitRootLogin' defined in `/etc/nixos/configuration.nix' has been renamed to `services.openssh.settings.PermitRootLogin'.
evaluation warning: The option `services.openssh.passwordAuthentication' defined in `/etc/nixos/configuration.nix' has been renamed to `services.openssh.settings.PasswordAuthentication'.
evaluation warning: The option `services.openssh.kbdInteractiveAuthentication' defined in `/etc/nixos/configuration.nix' has been renamed to `services.openssh.settings.KbdInteractiveAuthentication'.
evaluation warning: The option `services.xserver.libinput.touchpad' defined in `/etc/nixos/coregui.nix' has been renamed to `services.libinput.touchpad'.
evaluation warning: The option `services.xserver.libinput.enable' defined in `/etc/nixos/coregui.nix' has been renamed to `services.libinput.enable'.
evaluation warning: The option `services.xserver.displayManager.sddm.enable' defined in `/etc/nixos/coregui.nix' has been renamed to `services.displayManager.sddm.enable'.
evaluation warning: The option `services.xserver.displayManager.sddm.autoLogin.relogin' defined in `/etc/nixos/coregui.nix' has been renamed to `services.displayManager.sddm.autoLogin.relogin'.
evaluation warning: The option `services.xserver.displayManager.autoLogin' defined in `/etc/nixos/coregui.nix' has been renamed to `services.displayManager.autoLogin'.
evaluation warning: The option `hardware.opengl.enable' defined in `/etc/nixos/coregui.nix' has been renamed to `hardware.graphics.enable'.
evaluation warning: The option `fonts.fonts' defined in `/etc/nixos/coregui.nix' has been renamed to `fonts.packages'.

*/

# https://nixos.wiki/wiki/Cheatsheet
{ config, lib, pkgs, ... }:
let
  notsecret = {
    sshPubKeys = {
      alphaPubKey = builtins.readFile /env/notsecret/alpha.pub;
      ghPubKey = builtins.readFile /env/notsecret/gh.pub;
    };
  };
  unstableTarball =
    fetchTarball
      "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
in
{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      ./coregui.nix
      ./corecli.nix
      ./lavish.nix
      ./chromium.nix
      ./udev.nix
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "v4l2loopback" ];
  boot.kernelParams = [ "elevator=none" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-partuuid";

  fileSystems."/" = {
    device = "zpuddle/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "zpuddle/nix";
    fsType = "zfs";
  };

  fileSystems."/_projects" = {
    device = "zpuddle/projects";
    fsType = "zfs";
  };

  fileSystems."/_scratch" = {
    device = "zpuddle/scratch";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5DF7-6823";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/85864a8b-8282-4874-b846-f9e61767a05b"; }
  ];

  nix.settings.max-jobs = lib.mkDefault 8;
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
    # block harmful websites using steveblack's domain lists
    stevenblack = {
      enable = true;
      block = [ "fakenews" "gambling" "porn" "social" ];
    };
  };

  location = {
    # https://www.latlong.net/
    # Boulder, CO
    latitude = 40.016869;
    longitude = -105.279617;
    # Meadville, PA
    # latitude = 41.64801;
    # longitude = -80.14641;
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
      kbdInteractiveAuthentication = false;
      permitRootLogin = "prohibit-password";
      ports = [55000];
    };
  };

  time.timeZone = "America/Denver";

  users = {
    mutableUsers = true;
    users = {
      simon = {
        isNormalUser = true;
        home = "/home/simon" ;
        extraGroups = [ "wheel" "dialout" "audio" "video" "libvirtd" "docker" ];
        openssh = {
          authorizedKeys = {
            keys = [
              notsecret.sshPubKeys.ghPubKey
              notsecret.sshPubKeys.alphaPubKey
            ];
          };
        };
      };
    };
  };

  # enable nix-command, flakes
  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
    };
    docker ={
      enable = true;
    };
  };

  hardware.bluetooth.enable = true;

  system.stateVersion = "22.11";
}
