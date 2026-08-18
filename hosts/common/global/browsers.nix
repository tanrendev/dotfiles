{
  programs.chromium = {
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
}
