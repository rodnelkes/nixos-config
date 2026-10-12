{ promise, ... }@adios:

{
  options = {
    settings = {
      mergeFunc = adios.lib.merge.attrs.recursively;
      mutators = [ "/git" ];
    };
    ignoredPaths = {
      mergeFunc = adios.lib.merge.lists.concat;
      mutators = [ "/direnv" ];
    };
  };

  mutations = {
    "/git".settings = promise (
      { inputs }:
      let
        inherit (inputs.nixpkgs.pkgs) openssh;
        inherit (inputs.nixpkgs.lib) getExe';
      in
      {
        commit.gpgSign = true;
        tag.gpgSign = true;
        gpg = {
          format = "ssh";
          "ssh".program = getExe' openssh "ssh-keygen";
        };
      }
    );
  };

  result = promise (
    { options, inputs }:
    let
      inherit (builtins) concatStringsSep;
      inherit (inputs.nixpkgs.pkgs) writeText formats;
      generator = formats.gitIni { };

      excludesFile =
        if options ? ignoreFile then
          options.ignoreFile
        else if options ? ignoredPaths then
          writeText "ignore" (concatStringsSep "\n" options.ignoredPaths)
        else
          null;
    in
    inputs.mkWrapper {
      inherit (options) package;
      symlinks = {
        "$out/git/config" = generator.generate "config" (
          if excludesFile != null then
            if options.settings != null then
              options.settings // { core.excludesFile = excludesFile; }
            else
              { core.excludesFile = excludesFile; }
          else
            options.settings
        );
      };
      environment = {
        XDG_CONFIG_HOME = "$out";
      };
    }
  );
}
