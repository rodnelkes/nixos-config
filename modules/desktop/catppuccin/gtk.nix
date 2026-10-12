{ pkgs, ... }:
let
  theme = "catppuccin-mocha-mauve-standard";

  catppuccin-gtk = pkgs.catppuccin-gtk.override {
    accents = [ "mauve" ];
    variant = "mocha";
  };
in
{
  environment.sessionVariables = {
    GTK_THEME = theme;
    GTK_APPLICATION_PREFER_DARK_THEME = "1";
  };

  programs.dconf = {
    enable = true;

    profiles.user.databases = [
      {
        lockAll = true;

        settings = {
          "org/gnome/desktop/interface" = {
            gtk-theme = theme;
            color-scheme = "prefer-dark";
          };
        };
      }
    ];
  };

  hj.files.".local/share/themes/${theme}".source = "${catppuccin-gtk}/share/themes/${theme}";
}
