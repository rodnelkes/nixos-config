_:

{
  options = {
    config.mutators = [ "/jujutsu" ];
  };

  mutations = {
    "/jujutsu".config =
      { inputs }:
      let
        inherit (inputs.bupkes) user;
      in
      {
        user = {
          name = user.fullName;
          email = user.email;
        };

        signing = {
          behavior = "own";
          backend = "ssh";
          key = "/run/agenix/github";
        };
        git.sign-on-push = true;
        ui.show-cryptographic-signatures = true;
      };
  };
}
