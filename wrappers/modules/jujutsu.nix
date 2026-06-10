{ types, ... }@adios:

{
  inputs = {
    nixpkgs.from = { root }: root.nixpkgs;
    git.from = { root }: root.git;
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

      git = inputs.git { };
    in
    symlinkJoin {
      name = "jujutsu-wrapped";
      paths = [
        jujutsu
        git
      ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        mkdir -p $out/jj

        ln -sf ${writeTOML "config.toml" options.config} $out/jj/config.toml

        wrapProgram $out/bin/jj \
        --set JJ_CONFIG $out/jj \
        --set GIT_CONFIG_GLOBAL $out/git/config
      '';
      meta.mainProgram = "jj";
    };
}
