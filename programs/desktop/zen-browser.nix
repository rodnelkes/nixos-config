{
  sources,
  pkgs,
  lib,
  bupkes,
  ...
}:

let
  inherit (lib) mkIf;

  zen-browser = ((import sources.zen-browser) { inherit pkgs; }).twilight.override {
    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
  };
in
{
  environment.systemPackages = [ zen-browser ];

  persist.user.directories = mkIf bupkes.host.features.impermanence [
    ".cache/zen"
    ".config/zen"
  ];
}
