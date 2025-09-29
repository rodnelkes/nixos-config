{
  config,
  ...
}:
let
  homeConfig = config.flake.homeConfigurations.rodnelkes.config;
in
{
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;

      userName = "Zayen Yusuf";
      userEmail = "rodnelkes@gmail.com";

      signing = {
        signByDefault = true;
        format = "ssh";
        key = homeConfig.sops.secrets.github.path;
      };
    };
  };
}
