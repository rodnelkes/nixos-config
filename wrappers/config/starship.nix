_:

{
  inputs.nixpkgs.from = { root }: root.nixpkgs;

  mutations = {
    "/nushell".configPaths =
      { inputs }:
      let
        inherit (inputs.nixpkgs.pkgs) writeText runCommand starship;
        inherit (inputs.nixpkgs.pkgs.lib) getExe;

        config = writeText "starship-nushell-config" ''
          use ${
            runCommand "starship-nushell-config.nu" { } ''
              ${getExe starship} init nu >> "$out"
            ''
          }
        '';
      in
      [ config ];
  };
}
