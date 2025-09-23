{
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;

      userName = "Zayen Yusuf";
      userEmail = "rodnelkes@gmail.com";

      signing = {
        signByDefault = true;
        format = "ssh";
        key = "~/.ssh/github.pub";
      };
    };
  };
}
