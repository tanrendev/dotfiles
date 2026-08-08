{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    dmidecode
    dnsutils
    ethtool
    iw
    lm_sensors
    lsof
    mtr
    nvme-cli
    pciutils
    powertop
    smartmontools
    strace
    usbutils
    wayland-utils
    wev
  ];
}
