{
  flake.modules.homeManager.jujutsu = {
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
          key = "~/.ssh/github.pub";
        };
        git.sign-on-push = true;
        ui.show-cryptographic-signatures = true;
      };
    };
  };
}
