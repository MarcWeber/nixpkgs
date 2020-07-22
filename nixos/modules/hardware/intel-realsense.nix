# This module provides the proprietary NVIDIA X11 / OpenGL drivers.

{ config, lib, pkgs, ... }:

with lib;

let

  # maybe should be read from librealsense.src file 99-realsense-libusb.rules instead ?
  udev_rules = ''
# Intel RealSense UVC cameras (R200, F200, SR300 LR200, ZR300, D400, L500)
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0a80", MODE:="0666", GROUP:="plugdev", RUN+="/usr/local/bin/usb-R200-in_udev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0a66", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0aa5", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0abf", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0acb", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0ad0", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="04b4", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0ad1", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0ad2", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0ad3", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0ad4", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0ad5", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0ad6", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0af2", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0af6", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0afe", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0aff", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b00", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b01", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b03", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b07", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b0c", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b0d", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b3a", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b3d", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b48", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b49", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b4b", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b4d", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b52", MODE:="0666", GROUP:="plugdev"

# Intel RealSense recovery devices (DFU)
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0ab3", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0adb", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0adc", MODE:="0666", GROUP:="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b55", MODE:="0666", GROUP:="plugdev"

# Intel RealSense devices (Movidius, T265)
SUBSYSTEMS=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0af3", MODE="0666", GROUP="plugdev"
SUBSYSTEMS=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0b37", MODE="0666", GROUP="plugdev"
SUBSYSTEMS=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="03e7", ATTRS{idProduct}=="2150", MODE="0666", GROUP="plugdev"

KERNEL=="iio*", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0ad5", MODE:="0777", GROUP:="plugdev", RUN+="/bin/sh -c 'chmod -R 0777 /sys/%p'"
DRIVER=="hid_sensor_custom", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0ad5", RUN+="/bin/sh -c 'chmod -R 0777 /sys/%p && chmod 0777 /dev/%k'"
KERNEL=="iio*", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0af2", MODE:="0777", GROUP:="plugdev", RUN+="/bin/sh -c 'chmod -R 0777 /sys/%p'"
DRIVER=="hid_sensor*", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0af2", RUN+="/bin/sh -c 'chmod -R 0777 /sys/%p && chmod 0777 /dev/%k'"
KERNEL=="iio*", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0afe", MODE:="0777", GROUP:="plugdev", RUN+="/bin/sh -c 'chmod -R 0777 /sys/%p'"
DRIVER=="hid_sensor_custom", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0afe", RUN+="/bin/sh -c 'chmod -R 0777 /sys/%p && chmod 0777 /dev/%k'"
KERNEL=="iio*", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0aff", MODE:="0777", GROUP:="plugdev", RUN+="/bin/sh -c 'chmod -R 0777 /sys/%p'"
DRIVER=="hid_sensor_custom", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0aff", RUN+="/bin/sh -c 'chmod -R 0777 /sys/%p && chmod 0777 /dev/%k'"
KERNEL=="iio*", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b00", MODE:="0777", GROUP:="plugdev", RUN+="/bin/sh -c 'chmod -R 0777 /sys/%p'"
DRIVER=="hid_sensor_custom", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b00", RUN+="/bin/sh -c 'chmod -R 0777 /sys/%p && chmod 0777 /dev/%k'"
KERNEL=="iio*", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b01", MODE:="0777", GROUP:="plugdev", RUN+="/bin/sh -c 'chmod -R 0777 /sys/%p'"
DRIVER=="hid_sensor_custom", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b01", RUN+="/bin/sh -c 'chmod -R 0777 /sys/%p && chmod 0777 /dev/%k'"
KERNEL=="iio*", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b3a", MODE:="0777", GROUP:="plugdev", RUN+="/bin/sh -c 'chmod -R 0777 /sys/%p'"
DRIVER=="hid_sensor*", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b3a", RUN+="/bin/sh -c ' chmod -R 0777 /sys/%p && chmod 0777 /dev/%k'"
KERNEL=="iio*", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b3d", MODE:="0777", GROUP:="plugdev", RUN+="/bin/sh -c 'chmod -R 0777 /sys/%p'"
DRIVER=="hid_sensor*", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b3d", RUN+="/bin/sh -c ' chmod -R 0777 /sys/%p && chmod 0777 /dev/%k'"
KERNEL=="iio*", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b4b", MODE:="0777", GROUP:="plugdev", RUN+="/bin/sh -c 'chmod -R 0777 /sys/%p'"
DRIVER=="hid_sensor*", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b4b", RUN+="/bin/sh -c ' chmod -R 0777 /sys/%p && chmod 0777 /dev/%k'"
KERNEL=="iio*", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b4d", MODE:="0777", GROUP:="plugdev", RUN+="/bin/sh -c 'chmod -R 0777 /sys/%p'"
DRIVER=="hid_sensor*", ATTRS{idVendor}=="8086", ATTRS{idProduct}=="0b4d", RUN+="/bin/sh -c ' chmod -R 0777 /sys/%p && chmod 0777 /dev/%k'"


'';

in

{
  options = {
    hardware.intel.realsense.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
      Enable (intel) librealsense udev rules
      '';
    };
  };

  config = mkIf (config.hardware.intel.realsense.enable) {

    # services.udev.extraRules = udev_rules;
    environment.systemPackages = [ pkgs.librealsense ];
    services.udev.packages = [ pkgs.librealsense ];

  };

}
