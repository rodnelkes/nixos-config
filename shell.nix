{
  sources ? import ./bupkes/npins,
  pkgs ? import sources.nixpkgs { },
  bupkes ? import ./bupkes { inherit sources pkgs bupkes; },
  wrappers ? import ./wrappers { inherit sources pkgs bupkes; },
}:

pkgs.mkShellNoCC {
  allowSubstitues = false; # Prevent a cache.nixos.org call every time
  packages = with wrappers; [
    git
    jujutsu
    nushell
    wezterm
  ];
}
