{ types, ... }:

{
  inputs = {
    nixpkgs.from = { root }: root.nixpkgs;
    sources.from = { root }: root.sources;
  };

  options = {
    configPath.type = types.pathLike;
    wallpapers.type = types.listOf types.pathLike;
    facePath.type = types.pathLike;
  };

  impl =
    { inputs, options }:
    let
      inherit (inputs.nixpkgs.pkgs) symlinkJoin makeWrapper;
      noctalia = (import inputs.sources.noctalia { inherit (inputs.nixpkgs) pkgs; }).package;
    in
    symlinkJoin {
      name = "noctalia-wrapped";
      paths = [ noctalia ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        mkdir -p $out/noctalia

        ln -sf ${options.configPath} $out/noctalia/settings.toml

        wrapProgram $out/bin/noctalia \
        --set NOCTALIA_CONFIG_HOME $out
      '';
      meta.mainProgram = "noctalia";
    };
}
