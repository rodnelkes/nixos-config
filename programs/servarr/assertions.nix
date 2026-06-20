{
  bupkes,
  ...
}:
let
  inherit (builtins) elem length;
  inherit (bupkes.host.features.vpn) ports splitTunneling;

  hasModule = module: elem module bupkes.host.features.modules;
in
{
  assertions = [
    {
      assertion = hasModule "privacy";
      message = "servarr modules require privacy modules";
    }
    {
      assertion = splitTunneling;
      message = "qBittorrent and Prowlarr require split tunneling currently";
    }
    {
      assertion = ports != null && length ports != 0;
      message = "qBittorrent requires free ports";
    }
  ];
}
