{ types, ... }@adios:

{
  name = "nushell";

  inputs = {
    nixpkgs.path = "/nixpkgs";
  };

  options = {
    configPaths = {
      type = types.listOf types.pathLike;
      mutatorType = types.listOf types.pathLike;
      mergeFunc = adios.lib.merge.lists.concat;
    };
  };

  impl =
    { inputs, options }:
    let
      inherit (inputs.nixpkgs.pkgs)
        concatTextFile
        symlinkJoin
        makeWrapper
        nushell
        ;

      configFile = concatTextFile {
        name = "config.nu";
        files = options.configPaths;
      };
    in
    symlinkJoin {
      name = "nushell-wrapped";
      paths = [ nushell ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        mkdir -p $out/nushell
        ln -sf ${configFile} $out/nushell/config.nu
        wrapProgram $out/bin/nu \
        --add-flag "--config $out/nushell/config.nu"
      '';
      meta.mainProgram = "nu";
    };
}
