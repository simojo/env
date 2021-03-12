# core GUI environment; strictly non-machine-specific things that do not work from a TTY.
{ config, lib, pkgs, ... }:
let
  bspwmrcfile = builtins.readFile /env/dotfiles/bspwmrc;
  bspwmrc = pkgs.writeScript "bspwmrc" "${bspwmrcfile}";
in {
  environment = {
    systemPackages = [
      pkgs.alacritty
      pkgs.bemenu
      pkgs.feh
      pkgs.ffmpeg
      pkgs.hsetroot
      pkgs.lguf-brightness
      pkgs.libguestfs
      pkgs.libvirt
      pkgs.neofetch
      pkgs.polybar
      pkgs.redshift
      pkgs.rofi
      pkgs.scrot
      pkgs.slock
      pkgs.unstable.cairo
      pkgs.unstable.cairomm
      pkgs.unstable.chromium
      pkgs.unstable.guile-cairo
      pkgs.unstable.picom
      pkgs.virt-manager
      pkgs.xorg.xev
      pkgs.xorg.xmodmap
      pkgs.xorg.xset
    ];
    etc."sxhkdrc".text = builtins.readFile /env/dotfiles/sxhkdrc;
    etc."alacritty".text = builtins.readFile /env/dotfiles/alacritty.yml;
  };

  fonts.fonts = [
    pkgs.vistafonts
    pkgs.hack-font
    pkgs.font-awesome
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  programs.light.enable = true;

  services = {
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
          feh --bg-fill --no-xinerama /env/imgs/bg/bg.jpg || hsetroot -solid '#000000'
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
  };

  security = {
    wrappers = {
      slock = {
        source = "${pkgs.slock.out}/bin/slock";
      };
    };
  };
}
