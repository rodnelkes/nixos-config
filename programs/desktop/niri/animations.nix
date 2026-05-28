{
  lib,
  ...
}:
let
  inherit (lib) mkBefore;
in
{
  programs.niri.settings.animations =
    mkBefore
      # kdl
      ''
        animations {
            // For border animation pr
            // border-fade {
            //     duration-ms 200
            //     curve "ease-out-cubic"
            // }

            // border-angle {
            //     duration-ms 2000
            //     curve "linear"
            // }
        }
      '';
}
