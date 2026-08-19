{
  lib,
  ...
}:
let
  inherit (lib) mkBefore;
in
{
  programs.niri.settings.input =
    mkBefore
      # kdl
      ''
        input {
            keyboard {
                xkb {
                }

                numlock
            }

            touchpad {
                tap
                natural-scroll
            }

            mouse {
                scroll-button 274
            }

            trackpoint {
            }
        }
      '';
}
