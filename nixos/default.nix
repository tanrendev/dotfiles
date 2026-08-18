{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware.nix
    ./desktop.nix
  ];

  networking.hostName = "lyngen";

  programs.fish.enable = true;

  users.users.tanren = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "hm-backup";
    users.tanren = import ../home;
  };

  system.stateVersion = "26.05";

  nix = {
    registry = lib.mapAttrs (_: flake: { inherit flake; }) (
      lib.filterAttrs (_: lib.isType "flake") inputs
    );
    nixPath = [ "nixpkgs=flake:nixpkgs" ];

    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    optimise.automatic = true;
  };

  nixpkgs.config.allowUnfree = true;

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;

    plymouth = {
      enable = true;
      themePackages = [ (pkgs.catppuccin-plymouth.override { variant = "mocha"; }) ];
      theme = "catppuccin-mocha";
    };

    initrd = {
      systemd.enable = true;
      verbose = false;
    };

    consoleLogLevel = 0;

    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=false"
    ];
  };

  zramSwap.enable = true;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  networking.networkmanager.enable = true;

  virtualisation.docker.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
    ];
  };

  environment.systemPackages = with pkgs; [
    curl
    dmidecode
    dnsutils
    ethtool
    git
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
    wget
  ];
}
