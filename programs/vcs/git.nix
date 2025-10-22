{ config, ... }:

{
  hm = {
    programs.git = {
      enable = true;

      settings.user = {
        name = "Zayen Yusuf";
        email = "rodnelkes@gmail.com";
      };

      signing = {
        signByDefault = true;
        format = "ssh";
        key = config.age.secrets.github.path;
      };
    };
  };
}
