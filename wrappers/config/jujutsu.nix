_:

{
  options = {
    config.mutators = [ "/jujutsu" ];
  };

  mutations = {
    "/jujutsu".config =
      { inputs }:
      let
        inherit (inputs.bupkes) host user;

        signingKeyPath = "/run/agenix/github";
        signingKey = if host.hostname == "bingle" then "/persistent${signingKeyPath}" else signingKeyPath;
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
        };
        git.sign-on-push = true;
        ui.show-cryptographic-signatures = true;
      };
  };
}
