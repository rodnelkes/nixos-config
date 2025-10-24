{ bupkes, config, ... }:

{
  hm = {
    programs.jujutsu = {
      enable = true;

      settings = {
        user = {
          name = bupkes.user.fullName;
          email = bupkes.user.email;
        };

        signing = {
          behavior = "own";
          backend = "ssh";
          key = config.age.secrets.github.path;
        };
        git.sign-on-push = true;
        ui.show-cryptographic-signatures = true;
      };
    };
  };
}
