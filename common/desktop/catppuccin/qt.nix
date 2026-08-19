{ lib, bupkes, ... }:
let
  inherit (builtins) listToAttrs;
  inherit (lib) nameValuePair;
in
{
  hj.files = listToAttrs (
    map
      (
        qtct:
        nameValuePair ".config/${qtct}/${qtct}.conf" {
          text = ''
            [Appearance]
            color_scheme_path=${bupkes.user.homeDirectory}/.config/${qtct}/style-colors.conf
            custom_palette=true
            standard_dialogs=default
            style=kvantum
          '';
        }
      )
      [
        "qt5ct"
        "qt6ct"
      ]
  );
}
