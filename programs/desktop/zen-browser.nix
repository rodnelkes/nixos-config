{
  sources,
  pkgs,
  lib,
  bupkes,
  config,
  ...
}:

let
  inherit (pkgs) iproute2 firejail writeShellScriptBin;
  inherit (lib) getExe' getExe mkIf;

  ip = getExe' iproute2 "ip";
  ns = "protonvpn";

  zen-browser = (import sources.zen-browser) { inherit pkgs; };
  zen-twilight = zen-browser.twilight;
in
{
  programs.firejail.wrappedBinaries = mkIf config.programs.firejail.enable {
    "zen-twilight-${ns}" = {
      profile = "${firejail}/etc/firejail/zen-browser.profile";
      executable = "${getExe zen-twilight} -P ${ns}";
      extraArgs = [
        "--netns=${ns}"
        "--dns=10.2.0.1"
        "--dns=2a07:b944::2:1"
      ];
    };
  };

  environment.systemPackages = [
    zen-twilight
    (writeShellScriptBin "zen" ''
      if [[ $(${ip} netns identify) == ${ns} ]]; then
          exec zen-twilight-${ns} "$@"
      else
          exec zen-twilight -P "Default Profile" "$@"
      fi
    '')
  ];

  persist.user.directories = mkIf bupkes.host.features.impermanence [
    ".cache/zen"
    ".config/zen"

    "Downloads"
  ];
}
