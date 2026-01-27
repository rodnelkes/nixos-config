{ types, ... }@adios:

{
  name = "jujutsu";

  inputs = {
    nixpkgs.path = "/nixpkgs";
    bupkes.path = "/bupkes";
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
      inherit (inputs.nixpkgs.pkgs) symlinkJoin makeWrapper jujutsu;
      inherit (inputs.nixpkgs.pkgs.writers) writeTOML;
    in
    symlinkJoin {
      name = "jujutsu-wrapped";
      paths = [ jujutsu ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        mkdir -p $out/jj
        ln -sf ${writeTOML "config.toml" options.config} $out/jj/config.toml
        wrapProgram $out/bin/jj \
        --set JJ_CONFIG $out/jj
      '';
      meta.mainProgram = "jj";
    };
}
