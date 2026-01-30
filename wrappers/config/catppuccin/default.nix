{ types, ... }:

{
  name = "catppuccin";

  inputs = {
    nixpkgs.path = "/nixpkgs";
  };

  options = {
    nushell = {
      type = types.pathLike;
    };
  };

  mutations = {
    "/nushell".configPaths =
      { inputs, options }:
      let
        inherit (inputs.nixpkgs.pkgs) writeText;
        catppuccinNushell = options.nushell;

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
