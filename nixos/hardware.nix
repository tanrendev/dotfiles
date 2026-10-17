{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
let
  luks = "luks-17b54c25-8983-4852-87f2-899920585bde";
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = [ ];
      luks.devices.${luks}.device = "/dev/disk/by-uuid/17b54c25-8983-4852-87f2-899920585bde";
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/${luks}";
      fsType = "btrfs";
    };
    "/home" = {
      device = "/dev/mapper/${luks}";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };
    "/nix" = {
      device = "/dev/mapper/${luks}";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/BFE4-546A";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics.extraPackages = [ pkgs.intel-media-driver ];
  };

  environment = {
    sessionVariables.LIBVA_DRIVER_NAME = "iHD";

    systemPackages = with pkgs; [
      ffmpeg-full
      intel-gpu-tools
      libva-utils
    ];
  };

  services.thermald.enable = true;

  systemd.tmpfiles.rules = [
    "w /sys/class/power_supply/BAT0/charge_control_start_threshold - - - - 75"
    "w /sys/class/power_supply/BAT0/charge_control_end_threshold - - - - 80"
  ];
}
