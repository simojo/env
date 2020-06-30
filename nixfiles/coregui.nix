# core GUI environment; strictly non-machine-specific things that do not work from a TTY.
{ config, lib, pkgs, ... }:
let

  bspwmrcfile = builtins.readFile /env/dotfiles/bspwmrc;
  bspwmrc = pkgs.writeScript "bspwmrc" "${bspwmrcfile}";

in {
  # imports = [
  #   ./chromium.nix
  # ];

  environment = {
    systemPackages = [
      # FIXME: dunst.
      pkgs.alacritty
      pkgs.bemenu
      pkgs.chromium
      pkgs.ffmpeg
      pkgs.firefox
      pkgs.feh
      pkgs.hsetroot
      pkgs.minecraft
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

  programs = {
    yabar = {
      enable = true;
      bars."topbar" = {
        font = "Consolas";
        position = "top";
        extra = {
          "underline-size" = "2";
        };
        # fixed size matters; default is 80
        indicators = {
          "title" = {
            exec = "YABAR_TITLE";
            extra = {
              "variable-size" = "true";
            };
            align = "center";
            extra."underline-color-rgb" = "0x999999";
            extra."background-color-rgb" = "0x363636";
          };
          "battery" = {
            exec = "YABAR_BATTERY";
            extra = {
              "internal-option1" = "BAT0";
              "internal-suffix" = "%";
              "variable-size" = "true";
            };
            align = "center";
            extra."underline-color-rgb" = "0x999999";
            extra."background-color-rgb" = "0x363636";
          };
          "datetime" = {
            exec = "YABAR_DATE";
            extra = {
              "internal-option1" = "%a %d %T";
              "internal-prefix" = "";
              "interval" = "1";
              "variable-size" = "true";
            };
            align = "center";
            extra."underline-color-rgb" = "0x999999";
            extra."background-color-rgb" = "0x363636";
          };
          "volume" = {
            exec = "YBAR_VOLUME";
            extra = {
              "interval" = "1";
              "internal-option1" = "default Master 0"; # device mixer index
              "internal-option2" = "mapped"; # mapped will use logarithmic scale
              "internal-option3" = "🔈 🔇";
              "internal-suffix" = "%";
              "variable-size" = "true";
            };
            align = "left";
            extra."underline-color-rgb" = "0x999999";
            extra."background-color-rgb" = "0x363636";
          };
          "brightness" = {
            exec = "YABAR_BRIGHTNESS";
            extra = {
              "internal-option1" = "intel_backlight";
              "interval" = "1";
              "variable-size" = "true";
            };
            align = "left";
            extra."underline-color-rgb" = "0x999999";
            extra."background-color-rgb" = "0x363636";
          };
          "wifi" = {
            exec = "YABAR_WIFI";
            extra = {
              "internal-option1" = "wlp2s0";
              "variable-size" = "true";
            };
            align = "right";
            extra."underline-color-rgb" = "0x999999";
            extra."background-color-rgb" = "0x363636";
          };
          "bandwidth" = {
            exec = "YABAR_BANDWIDTH";
            extra = {
              "internal-option1" = "default";
              "internal-option2" = "↓ ↑";
              "interval" = "2";
              "fixed-size" = "500";
            };
            align = "right";
            extra."underline-color-rgb" = "0x999999";
            extra."background-color-rgb" = "0x363636";
          };
        };
      };
    };
  };

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
          feh --bg-fill /env/imgs/bg/bloom.jpg || hsetroot -solid '#000000'
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
