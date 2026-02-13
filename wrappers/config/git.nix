_:

{
  options = {
    config.mutators = [ "/git" ];
  };

  mutations = {
    "/git".config =
      { inputs }:
      let
        inherit (inputs.bupkes) host user;
        inherit (inputs.nixpkgs) lib pkgs;

        signingKeyPath = "/run/agenix/github";
        signingKey = if host.hostname == "bingle" then "/persistent${signingKeyPath}" else signingKeyPath;
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
          "ssh".program = lib.getExe' pkgs.openssh "ssh-keygen";
        };
      };
  };
}
