{
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (builtins) split;
  inherit (lib)
    last
    genAttrs'
    nameValuePair
    mkIf
    ;
  inherit (bupkes.wrappers.noctalia) wallpapers facePath;

  getWallpaperName = filePath: last (split "/" (toString filePath));
  wallpaperSources = genAttrs' wallpapers (
    wallpaper:
    nameValuePair "Pictures/Wallpapers/${getWallpaperName wallpaper}" { source = toString wallpaper; }
  );
in
{
  environment.systemPackages = [
    bupkes.wrappers.noctalia.drv
    pkgs.xwayland-satellite
  ];

  qt.enable = true;

  programs.niri.settings = {
    top-level =
      # kdl
      ''
        spawn-at-startup "noctalia"
      '';
    window-rule =
      # kdl
      ''
        window-rule {
            geometry-corner-radius 20
            clip-to-geometry true
        }

        window-rule {
          match app-id="dev.noctalia.Noctalia"
          open-floating true
          default-column-width { fixed 1080; }
          default-window-height { fixed 920; }
        }
      '';
    layer-rule =
      # kdl
      ''
        layer-rule {
          match namespace="^noctalia-backdrop"
          place-within-backdrop true
        }
      '';
    debug =
      # kdl
      ''
        debug {
          honor-xdg-activation-with-invalid-serial
        }
      '';
  };

  hj.files = wallpaperSources // {
    ".face".source = facePath;
  };

  persist.user.directories = mkIf bupkes.host.features.impermanence [
    ".cache/noctalia"
    ".local/state/noctalia"
  ];
}
