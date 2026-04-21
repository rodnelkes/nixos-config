{ types, ... }:

{
  inputs.nixpkgs.path = "/nixpkgs";

  options = {
    config.type = types.string;

    hosts.type = types.string;
  };

  impl =
    { inputs, options }:
    let
      inherit (inputs.nixpkgs.pkgs)
        symlinkJoin
        makeWrapper
        gh
        writeText
        ;

      inherit (options) config hosts;
    in
    symlinkJoin {
      name = "gh-wrapped";
      paths = [ gh ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        mkdir -p $out/gh

        ln -sf ${writeText "config.yml" config} $out/gh/config.yml
        ln -sf ${writeText "hosts.yml" hosts} $out/gh/hosts.yml

        wrapProgram $out/bin/gh \
        --set GH_CONFIG_DIR $out/gh
      '';
      meta.mainProgram = "gh";
    };
}
