{ types, ... }@adios:

{
  inputs.nixpkgs.from = { root }: root.nixpkgs;

  options = {
    config = {
      type = types.attrs;
      mutatorType = types.attrs;
      mergeFunc = adios.lib.merge.attrs.recursively;
    };

    excludes = {
      type = types.string;
      mutatorType = types.string;
      mergeFunc = adios.lib.merge.strings.concatLines;
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
      inherit (inputs.nixpkgs.pkgs.lib.generators) toGitINI;

      excludesFile = writeText "exclude" options.excludes;
      config = options.config // {
        core = { inherit excludesFile; };
      };
    in
    symlinkJoin {
      name = "git-wrapped";
      paths = [ git ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        mkdir -p $out/git

        ln -sf ${writeText "config" (toGitINI config)} $out/git/config

        wrapProgram $out/bin/git \
        --set XDG_CONFIG_HOME $out
      '';
      meta.mainProgram = "git";
    };
}
