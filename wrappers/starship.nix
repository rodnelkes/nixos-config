{ promise, ... }:

{
  inputs.nixpkgs.from = { parent }: parent.nixpkgs;

  mutations = {
    "/nushell".sourceFiles = promise (
      { inputs }:
      let
        inherit (inputs.nixpkgs.pkgs) writeText runCommand starship;
        inherit (inputs.nixpkgs.lib) getExe;

        config = writeText "starship-nushell-config" ''
          use ${
            runCommand "starship-nushell-config.nu" { } ''
              ${getExe starship} init nu >> "$out"
            ''
          }
        '';
      in
      [ config ]
    );
  };
}
