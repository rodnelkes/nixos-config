_:

{
  inputs = {
    bupkes.path = "/bupkes";
  };

  options = {
    config.mutators = [ "/git" ];
    excludesFile.mutators = [ "/neovim" ];
  };

  mutations = {
    "/git".config =
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
          inherit signingKey;

          name = user.fullName;
          email = user.email;
        };

        commit.gpgSign = true;
        tag.gpgSign = true;
        gpg = {
          format = "ssh";
          "ssh" = {
            allowedSignersFile = allowedSigners;
            program = lib.getExe' pkgs.openssh "ssh-keygen";
          };
        };
      };
  };
}
