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
      pkgs.dunst
      pkgs.polybar
      pkgs.alacritty
      pkgs.bemenu
      pkgs.chromium
      pkgs.ffmpeg
      pkgs.firefox
      pkgs.feh
      pkgs.hsetroot
      pkgs.minecraft
      pkgs.neofetch
      pkgs.scrot
      pkgs.slock
      pkgs.xorg.xmodmap
      pkgs.xorg.xset
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
      autoRepeatDelay = 200;
      autoRepeatInterval = 20;
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
        # {
        #   output = "eDP-1";
        #   primary = true;
        #   monitorConfig = ''
        #     DisplaySize 1920 1080
        #   '';
        # }
        # {
        #   output = "DP-1";
        #   monitorConfig = ''
        #     DisplaySize 3840 2160
        #     Option "Rotate" "left"
        #   '';
        # }
        # {
        #   output = "DP-2";
        #   monitorConfig = ''
        #     DisplaySize 3840 2160
        #     Option "Rotate" "left"
        #   '';
        # }
      ];
    };
  };

  security = {
    wrappers = {
      slock = {
        source = "${pkgs.slock.out}/bin/slock";
      };
    };
  };
}
