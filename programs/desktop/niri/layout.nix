{
  lib,
  ...
}:
let
  inherit (lib) mkBefore;
in
{
  programs.niri.settings.layout =
    mkBefore
      # kdl
      ''
        layout {
            gaps 16

            center-focused-column "never"

            preset-column-widths {
                proportion 0.33333
                proportion 0.5
                proportion 0.66667
            }

            default-column-width { proportion 0.5; }

            focus-ring {
                off

                width 4

                active-color "#7fc8ff"

                inactive-color "#505050"
            }

            border {
                width 4

                active-gradient from="#fab387" to="#f9e2af" relative-to="workspace-view"
                inactive-color "#b4befe" 
                urgent-gradient from="#f38ba8" to="#eba0ac" relative-to="workspace-view"
            }

            shadow {
                softness 30

                spread 5

                offset x=0 y=5

                color "#0007"
            }

            struts {
            }
        }
      '';
}
