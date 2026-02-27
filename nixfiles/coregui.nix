# core GUI environment; strictly non-machine-specific things that do not work from a TTY.
{ config, lib, pkgs, ... }:
let
  bspwmrcfile = builtins.readFile /env/dotfiles/bspwmrc;
  bspwmrc = pkgs.writeScript "bspwmrc" "${bspwmrcfile}";
in {
  environment = {
    systemPackages = [
      pkgs.alacritty
      pkgs.electron
      pkgs.feh
      pkgs.ffmpeg
      pkgs.gimp
      pkgs.gthumb
      pkgs.hsetroot
      pkgs.lguf-brightness
      pkgs.libGL
      pkgs.libguestfs
      pkgs.libvirt
      pkgs.logseq
      pkgs.mplayer
      pkgs.neofetch
      (pkgs.polybar.override { pulseSupport = true; })
      pkgs.redshift
      pkgs.rofi
      pkgs.scrot
      pkgs.unstable.cairo
      pkgs.unstable.cairomm
      pkgs.unstable.chromium
      pkgs.unstable.guile-cairo
      pkgs.virt-manager
      pkgs.vscode
      pkgs.xorg.xev
      pkgs.xorg.xhost
      pkgs.xorg.xmodmap
      pkgs.xorg.xset
    ];
    etc."sxhkdrc".text = builtins.readFile /env/dotfiles/sxhkdrc;
    etc."alacritty".text = builtins.readFile /env/dotfiles/alacritty.toml;
  };

  fonts.fonts = [
    pkgs.vistafonts
    pkgs.hack-font
    pkgs.font-awesome
    pkgs.roboto-mono
  ];

  hardware.opengl.enable = true;

  programs.light.enable = true;
  programs.slock.enable = true;

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
    pipewire = {
      enable = true;
      audio.enable = true;
    };
    xserver = {
      libinput.enable = true;
      libinput.touchpad.naturalScrolling = false;
      autoRepeatDelay = 300;
      autoRepeatInterval = 30;
      desktopManager = {
        xfce = {
          enable = false;
        };
      };
      displayManager = {
        autoLogin = {
          enable = true;
          user = "simon";
        };
        sddm = {
          enable = true;
          autoLogin = {
            relogin = false;
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
      windowManager = {
        bspwm = {
          enable = true;
          configFile = "${bspwmrc}";
          sxhkd = {
            configFile = "/etc/sxhkdrc";
          };
        };
      };
      xkb.layout = "us";
      xkb.options = "caps:escape";
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
