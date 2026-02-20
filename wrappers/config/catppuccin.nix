_:

{
  name = "catppuccin";

  inputs = {
    sources.path = "/sources";
    nixpkgs.path = "/nixpkgs";
  };

  mutations = {
    "/nushell".configPaths =
      { inputs }:
      let
        inherit (inputs.nixpkgs.pkgs) writeText;
        catppuccinNushell = inputs.sources.catppuccin-nushell.outPath;

        config =
          writeText "nushell-catppuccin-mocha"
            # nu
            ''
              source ${catppuccinNushell}/themes/catppuccin_mocha.nu
            '';
      in
      [ config ];
  };
}
