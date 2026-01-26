_:

{
  options = {
    config.mutators = [ "/git" ];
  };

  mutations = {
    "/git".config =
      { inputs }:
      let
        inherit (inputs.bupkes) user;
        inherit (inputs.nixpkgs) lib pkgs;
      in
      {
        user = {
          name = user.fullName;
          email = user.email;
          signingKey = "/run/agenix/github";
        };

        commit.gpgSign = true;
        tag.gpgSign = true;
        gpg = {
          format = "ssh";
          "ssh".program = lib.getExe' pkgs.openssh "ssh-keygen";
        };
      };
  };
}
