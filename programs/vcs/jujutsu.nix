{ config, ... }:

{
  hm = {
    programs.jujutsu = {
      enable = true;

      settings = {
        user = {
          name = "Zayen Yusuf";
          email = "rodnelkes@gmail.com";
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
