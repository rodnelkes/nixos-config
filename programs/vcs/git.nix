{ bupkes, config, ... }:

{
  hm = {
    programs.git = {
      enable = true;

      settings.user = {
        name = bupkes.user.fullName;
        email = bupkes.user.email;
      };

      signing = {
        signByDefault = true;
        format = "ssh";
        key = config.age.secrets.github.path;
      };
    };
  };
}
