_:

{
  inputs = {
    bupkes.path = "/bupkes";
  };

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
        inherit (inputs.bupkes) host user;
        inherit (inputs.nixpkgs) lib pkgs;

        persistPath = string: if host.features.impermanence then "/persistent${string}" else string;
        signingKey = persistPath "/run/agenix/github";
        allowedSigners = persistPath "/run/agenix/allowed-signers";
      in
      {
        user = {
          name = user.fullName;
          email = user.email;
        };

        signing = {
          behavior = "own";
          backend = "ssh";
          key = signingKey;

          backends.ssh = {
            allowed-signers = allowedSigners;
            program = lib.getExe' pkgs.openssh "ssh-keygen";
          };
        };
        git.sign-on-push = true;
        ui.show-cryptographic-signatures = true;

        snapshot.max-new-file-size = 39489754;

        remotes.origin.auto-track-bookmarks = "*";

        git.private-commits = "description('private:*')";
      };
  };
}
