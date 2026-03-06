{ types, ... }@adios:

{
  name = "jujutsu";

  inputs = {
    nixpkgs.path = "/nixpkgs";
    git.path = "/git";
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
        jujutsu
        writeText
        ;
      inherit (inputs.nixpkgs.pkgs.writers) writeTOML;
      inherit (inputs.nixpkgs.lib.generators) toGitINI;
    in
    symlinkJoin {
      name = "jujutsu-wrapped";
      paths = [ jujutsu ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        mkdir -p $out/jj
        mkdir -p $out/git

        ln -sf ${writeTOML "config.toml" options.config} $out/jj/config.toml
        ln -sf ${writeText "config" (toGitINI inputs.git.config)} $out/git/config
        ln -sf ${writeText "ignore" inputs.git.excludesFile} $out/git/ignore

        wrapProgram $out/bin/jj \
        --set JJ_CONFIG $out/jj \
        --set XDG_CONFIG_HOME $out
      '';
      meta.mainProgram = "jj";
    };
}
