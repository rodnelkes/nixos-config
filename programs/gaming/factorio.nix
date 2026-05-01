{
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (pkgs) steam-run;
  inherit (lib) getExe;
  inherit (bupkes.user) homeDirectory;
in
{
  hj.files.".local/share/applications/Factorio.desktop" = {
    text = ''
      [Desktop Entry]
      Name=Factorio
      Exec=${getExe steam-run} ${homeDirectory}/Games/factorio/bin/x64/factorio
      Icon=${homeDirectory}/Games/factorio/data/core/graphics/factorio.png
      Type=Application
      Categories=Game;
      StartupWMClass=factorio
    '';
    executable = true;
  };
}
