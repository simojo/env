let
  unstable = import (builtins.fetchGit {
    name = "nixos-unstable-2024-10-09";
    url = "https://github.com/nixos/nixpkgs/";
    ref = "refs/heads/nixos-unstable";
    rev = "c31898adf5a8ed202ce5bea9f347b1c6871f32d1";
  }) {};
  shellname = "arduino-custom";
  udevrules = ''
# UDEV Rules for Micronucleus boards including the Digispark.
# This file must be placed at:
#
# /etc/udev/rules.d/49-micronucleus.rules    (preferred location)
#   or
# /lib/udev/rules.d/49-micronucleus.rules    (req'd on some broken systems)
#
# To install, type these commands in a terminal:
#   sudo cp 49-micronucleus.rules /etc/udev/rules.d/49-micronucleus.rules
#   sudo udevadm control --reload-rules
#
# After this file is copied, physically unplug and reconnect the board.
#
SUBSYSTEMS=="usb", ATTRS{idVendor}=="16d0", ATTRS{idProduct}=="0753", MODE:="0666"
KERNEL=="ttyACM*", ATTRS{idVendor}=="16d0", ATTRS{idProduct}=="0753", MODE:="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
#
# If you share your linux system with other users, or just don't like the
# idea of write permission for everybody, you can replace MODE:="0666" with
# OWNER:="yourusername" to create the device owned by you, or with
# GROUP:="somegroupname" and mange access using standard unix groups.'';
in
  unstable.stdenv.mkDerivation {
    name = shellname;
    buildInputs = [
      unstable.arduino
      unstable.arduino-cli
      unstable.arduino-language-server
      unstable.screen
      unstable.usbutils
    ];
    installPhase = ''
      mkdir -p $out/etc/udev/rules.d
      echo > $out/etc/udev/rules.d/49-micronucleus.rules << EOL
      ${udevrules}
      EOL
    '';
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
    '';
  }
