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
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      ./coregui.nix
      ./corecli.nix
      ./lavish.nix
      ./chromium.nix
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
  };

  location = {
    # https://www.latlong.net/
    # Madrid, Spain
    latitude = 40.416775;
    longitude = -3.703790;
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

  time.timeZone = "America/New_York";

  users = {
    mutableUsers = true;
    extraGroups.vboxusers.members = [ "simon" ];
    users = {
      simon = {
        isNormalUser = true;
        home = "/home/simon" ;
        extraGroups = [ "wheel" "audio" "video" "libvirtd" "docker" ];
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
    virtualbox.host = {
      enable = true;
    };
    docker ={
      enable = true;
    };
  };

  hardware.bluetooth.enable = true;

  system.stateVersion = "22.11";
}
