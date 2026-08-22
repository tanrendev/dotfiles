{ inputs, pkgs, ... }:
{
  imports = [
    inputs.noctalia.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
  ];

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };

    noctalia = {
      enable = true;
      recommendedServices.enable = true;
    };

    noctalia-greeter = {
      enable = true;
      settings = {
        session.default = "Hyprland (uwsm-managed)";
        appearance.scheme = "Synced";
      };
    };

    gpu-screen-recorder.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };

    chromium = {
      enable = true;

      extraOpts = {
        MetricsReportingEnabled = false;
        UrlKeyedAnonymizedDataCollectionEnabled = false;
        SafeBrowsingProtectionLevel = 0;
        SyncDisabled = true;
        SearchSuggestEnabled = false;
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        SpellCheckServiceEnabled = false;
        TranslateEnabled = false;
        NetworkPredictionOptions = 2;
        BackgroundModeEnabled = false;
        DefaultBrowserSettingEnabled = false;
        WebRtcIPHandling = "default_public_interface_only";
        HttpsOnlyMode = "force_enabled";

        BraveRewardsDisabled = true;
        BraveWalletDisabled = true;
        BraveVPNDisabled = true;
        BraveAIChatEnabled = false;
        BraveLocalAIEnabled = false;
        BraveNewsDisabled = true;
        BraveTalkDisabled = true;
        BravePlaylistEnabled = false;
        BraveP3AEnabled = false;
        BraveStatsPingEnabled = false;
        BraveWebDiscoveryEnabled = false;
        BraveDeAmpEnabled = true;
        BraveDebouncingEnabled = true;
        BraveGlobalPrivacyControlEnabled = true;
        BraveReduceLanguageEnabled = true;
        BraveTrackingQueryParametersFilteringEnabled = true;
        BraveWaybackMachineEnabled = false;
        EmailAliasesEnabled = false;
        IPFSEnabled = false;
        TorDisabled = true;
      };
    };
  };

  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = [ pkgs.file-roller ];
  };

  fonts = {
    packages = with pkgs; [
      departure-mono
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];

    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  security = {
    rtkit.enable = true;
    polkit = {
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.noctalia.greeter.apply-appearance" && subject.user == "tanren") {
            return polkit.Result.YES;
          }
        });
      '';
    };
  };

  services = {
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    power-profiles-daemon.enable = true;

    upower = {
      enable = true;
      criticalPowerAction = "PowerOff";
    };

    tumbler.enable = true;
    udisks2.enable = true;
    gvfs.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };
}
