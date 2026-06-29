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
        inherit (inputs.nixpkgs.pkgs.lib) getExe' getExe;
      in
      {
        user = {
          name = "Zayen Yusuf";
          email = "rodnelkes";
        };

        signing = {
          behavior = "own";
          backend = "ssh";
          key = "/persistent/run/agenix/github";

          backends.ssh = {
            allowed-signers = "/persistent/run/agenix/allowed-signers";
            program = getExe' openssh "ssh-keygen";
          };
        };
        git.sign-on-push = true;
        ui.show-cryptographic-signatures = true;

        snapshot.max-new-file-size = 9870896;

        remotes.origin.auto-track-bookmarks = "*";

        git.private-commits = "description('private:*')";

        git.executable-path = getExe (inputs.git { });
      };
  };
}
