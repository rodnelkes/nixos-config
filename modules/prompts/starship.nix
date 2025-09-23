let
  jetpackConfig = builtins.readFile (
    builtins.fetchurl {
      url = "https://raw.githubusercontent.com/starship/starship/6526d4bb5e26443f78992db38c8a2fd0154002cb/docs/public/presets/toml/jetpack.toml";
      sha256 = "4957188eeb0018d68f3fa77e1a53a8134263e221cc2db02a575bcedf85c97403";
    }
  );
  jetpackCatppuccin = builtins.readFile (
    builtins.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/starship/5906cc369dd8207e063c0e6e2d27bd0c0b567cb8/themes/mocha.toml";
      sha256 = "712699ad27db93deddda4577ab9753f76e0c82652e63c7982085343c8ca01f9c";
    }
  );
in
{
  flake.modules.homeManager.starship = {
    programs.starship = {
      enable = true;

      settings = (builtins.fromTOML jetpackConfig) // (builtins.fromTOML jetpackCatppuccin);
    };
  };
}
