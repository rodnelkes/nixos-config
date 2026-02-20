{ types, ... }@adios:

{
  name = "git";

  inputs = {
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
      inherit (inputs.nixpkgs.pkgs)
        symlinkJoin
        makeWrapper
        git
        writeText
        ;
      inherit (inputs.nixpkgs.lib.generators) toGitINI;
    in
    symlinkJoin {
      name = "git-wrapped";
      paths = [ git ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        mkdir -p $out/git
        ln -sf ${writeText "config" (toGitINI options.config)} $out/git/config
        wrapProgram $out/bin/git \
        --set XDG_CONFIG_HOME $out
      '';
      meta.mainProgram = "git";
    };
}
