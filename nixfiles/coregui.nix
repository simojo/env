# core GUI environment; strictly non-machine-specific things that do not work from a TTY.
{ config, lib, pkgs, ... }:
let

  bspwmrcfile = builtins.readFile /env/dotfiles/bspwmrc;
  bspwmrc = pkgs.writeScript "bspwmrc" "${bspwmrcfile}";

in {
  imports = [
    ./chromium.nix
  ];

  environment = {
    systemPackages = [
      pkgs.polybar
      pkgs.alacritty
      pkgs.bemenu
      pkgs.chromium
      pkgs.discord
      pkgs.ffmpeg
      pkgs.feh
      pkgs.hsetroot
      pkgs.libvirt
      pkgs.lmms
      pkgs.neofetch
      pkgs.scrot
      pkgs.shotcut
      pkgs.slock
      pkgs.xorg.xmodmap
      pkgs.xorg.xset
      pkgs.youtube-dl
      pkgs.zoom-us
    ];
    etc."sxhkdrc".text = builtins.readFile /env/dotfiles/sxhkdrc;
    etc."alacritty".text = builtins.readFile /env/dotfiles/alacritty;
  };

  fonts.fonts = [
    pkgs.vistafonts
    pkgs.hack-font
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  location = {
    # https://www.latlong.net/
    latitude = 41.646099;
    longitude = -80.147148;
  };

  programs.light.enable = true;

  services = {
    redshift = {
      enable = true;
      temperature = {
        day = 5500;
        night = 4200;
      };
    };
    unclutter = {
      enable = true;
    };
    xserver = {
      libinput.enable = true;
      libinput.naturalScrolling = false;
      autoRepeatDelay = 300;
      autoRepeatInterval = 30;
      desktopManager = {
        xfce = {
          enable = false;
        };
      };
      displayManager = {
        sddm = {
          enable = true;
          autoLogin = {
            enable = true;
            relogin = false;
            user = "simon";
          };
        };
        sessionCommands = ''
          xset -dpms
          xset s 6000 6000
          xset s off
          xset s noblank
          xset s noexpose
          feh --bg-fill /env/imgs/bg/bg.jpg || hsetroot -solid '#000000'
          hsetroot -solid '#000000'
          light -N 1.0
        '';
      };
      enable = true;
      layout = "us";
      windowManager = {
        bspwm = {
          enable = true;
          configFile = "${bspwmrc}";
          sxhkd = {
            configFile = "/etc/sxhkdrc";
          };
        };
      };
      xkbOptions = "caps:escape";
      xrandrHeads = [
      ];
    };
    picom.enable = true;
  };

  security = {
    wrappers = {
      slock = {
        source = "${pkgs.slock.out}/bin/slock";
      };
    };
  };
}
