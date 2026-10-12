{ promise, ... }:

{
  inputs = {
    sources.from = { parent }: parent.sources;
    nixpkgs.from = { parent }: parent.nixpkgs;
  };

  mutations = {
    "/nushell".sourceFiles = promise (
      { inputs }:
      let
        inherit (inputs.nixpkgs.pkgs) writeText;
        catppuccinNushell = inputs.sources.catppuccin-nushell.outPath;
        catppuccinFzf = inputs.sources.catppuccin-fzf.outPath;

        config =
          writeText "nushell-catppuccin-mocha"
            # nu
            ''
              source ${catppuccinNushell}/themes/catppuccin_mocha.nu
              source ${catppuccinFzf}/themes/catppuccin-fzf-mocha.nu
            '';
      in
      [ config ]
    );
  };
}
