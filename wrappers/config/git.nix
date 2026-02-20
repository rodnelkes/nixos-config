_:

{
  options = {
    config.mutators = [ "/git" ];
  };

  mutations = {
    "/git".config =
      { inputs }:
      let
        inherit (inputs.bupkes.default) host user;
        inherit (inputs.nixpkgs) lib pkgs;

        persist = string: "/persistent${string}";

        signingKeyPath = "/run/agenix/github";
        signingKey = if host.hostname == "bingle" then persist signingKeyPath else signingKeyPath;

        allowedSignersPath = "/run/agenix/allowed-signers";
        allowedSigners =
          if host.hostname == "bingle" then persist allowedSignersPath else allowedSignersPath;
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
