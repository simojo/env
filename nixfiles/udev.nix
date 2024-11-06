{ config, lib, pkgs, ... }:

{
  services.udev.extraRules = ''
# ###############
# ## Digispark ##
# ###############

#
# If you share your linux system with other users, or just don't like the
# idea of write permission for everybody, you can replace MODE:="0666" with
# OWNER:="yourusername" to create the device owned by you, or with
# GROUP:="somegroupname" and mange access using standard unix groups.
#
# ModemManager tends to interfere with USB Serial devices like Teensy.
# Problems manifest as the Arduino Serial Monitor missing some incoming
# data, and "Unable to open /dev/ttyACM0 for reboot request" when
# uploading.  If you experience these problems, disable or remove
# ModemManager from your system.  If you must use a modem, perhaps
# try disabling the "MM_FILTER_RULE_TTY_ACM_INTERFACE" ModemManager
# rule.  Changing ModemManager's filter policy from "strict" to "default"
# may also help.  But if you don't use a modem, completely removing
# the troublesome ModemManager is the most effective solution.

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
# GROUP:="somegroupname" and mange access using standard unix groups.
  '';
}
