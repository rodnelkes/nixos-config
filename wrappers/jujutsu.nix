{ types, promise, ... }@adios:

{
  options = {
    settings = {
      mergeFunc = adios.lib.merge.attrs.recursively;
      mutators = [
        "/jujutsu"
        "/neovim"
      ];
    };
    git.type = types.derivation;
  };

  mutations = {
    "/jujutsu".settings = promise (
      { inputs }:
      let
        inherit (inputs.nixpkgs.pkgs) openssh;
        inherit (inputs.nixpkgs.lib) getExe';
      in
      {
        signing = {
          behavior = "own";
          backend = "ssh";

          backends.ssh.program = getExe' openssh "ssh-keygen";
        };
        git.sign-on-push = true;
        ui.show-cryptographic-signatures = true;

        snapshot.max-new-file-size = 9870896;

        remotes.origin.auto-track-bookmarks = "*";

        git.private-commits = "description('private:*')";
      }
    );
  };

  result = promise (
    { options, inputs }:
    let
      inherit (inputs.nixpkgs.pkgs) formats;
      inherit (inputs.nixpkgs.lib) makeBinPath;
      generator = formats.toml { };
    in
    inputs.mkWrapper {
      inherit (options) package;
      extraPaths = [ options.git ];
      symlinks = {
        "$out/jj-config/config.toml" =
          if options ? configFile then
            options.configFile
          else if options ? settings then
            generator.generate "config.toml" options.settings
          else
            null;
      };
      wrapperArgs =
        if options ? extraPackages then
          ''
            --prefix PATH : ${makeBinPath options.extraPackages}
          ''
        else
          "";
      environment = {
        JJ_CONFIG = "$out/jj-config";
        GIT_CONFIG_GLOBAL = "$out/git/config";
      };
    }
  );
}
