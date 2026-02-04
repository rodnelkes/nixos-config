{ types, ... }@adios:

{
  name = "starship";

  inputs = {
    sources.path = "/sources";
    nixpkgs.path = "/nixpkgs";
  };

  options = {
    config = {
      type = types.attrs;
      mutatorType = types.attrs;
      mergeFunc = adios.lib.merge.attrs.recursively;
    };
  };

  impl =
    { inputs, options }:
    let
      inherit (inputs.nixpkgs.pkgs) symlinkJoin makeWrapper starship;
      inherit (inputs.nixpkgs.pkgs.writers) writeTOML;

      configFile = writeTOML "starship.toml" options.config;
    in
    symlinkJoin {
      name = "starship-wrapped";
      paths = [ starship ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        ln -sf ${configFile} $out/starship.toml
        wrapProgram $out/bin/starship \
        --set STARSHIP_CONFIG $out/starship.toml
      '';
      meta.mainProgram = "starship";
    };
}
