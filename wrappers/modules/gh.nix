{ types, ... }@adios:

{
  inputs.nixpkgs.from = { root }: root.nixpkgs;

  options = {
    config = {
      type = types.attrs;
      mergeFunc = adios.lib.merge.attrs.recursively;
    };
    hosts = {
      type = types.attrs;
      mergeFunc = adios.lib.merge.attrs.recursively;
    };
  };

  impl =
    { inputs, options }:
    let
      inherit (inputs.nixpkgs.pkgs) symlinkJoin makeWrapper gh;
      inherit (inputs.nixpkgs.pkgs.writers) writeYAML;

      inherit (options) config hosts;
    in
    symlinkJoin {
      name = "gh-wrapped";
      paths = [ gh ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        mkdir -p $out/gh

        ln -sf ${writeYAML "config.yml" config} $out/gh/config.yml
        ln -sf ${writeYAML "hosts.yml" hosts} $out/gh/hosts.yml

        wrapProgram $out/bin/gh \
        --set GH_CONFIG_DIR $out/gh
      '';
      meta.mainProgram = "gh";
    };
}
