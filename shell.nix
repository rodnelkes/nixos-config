{
  sources ? import ./bupkes/npins,
  pkgs ? import sources.nixpkgs { },
  wrappers ? import ./wrappers { inherit sources pkgs; },
}:
let
  inherit (pkgs) mkShellNoCC;

  wrapperDrvs = map (wrapper: wrapper.drv) (
    with wrappers;
    [
      gh
      git
      jujutsu
      noctalia
      nushell
      vesktop
      wezterm
    ]
  );
in
mkShellNoCC {
  allowSubstitutes = false; # Prevent a cache.nixos.org call every time

  packages = wrapperDrvs;
}
