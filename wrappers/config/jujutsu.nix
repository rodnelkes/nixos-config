_:

{
  options = {
    config.mutators = [
      "/jujutsu"
      "/neovim"
    ];
  };

  mutations = {
    "/jujutsu".config =
      { inputs }:
      let
        inherit (inputs.nixpkgs.pkgs) openssh;
        inherit (inputs.nixpkgs.pkgs.lib) getExe';
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
      };
  };
}
