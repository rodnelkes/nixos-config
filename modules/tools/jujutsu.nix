{
  config,
  ...
}:
let
  homeConfig = config.flake.homeConfigurations.rodnelkes.config;
in
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
          key = homeConfig.sops.secrets.github.path;
        };
        git.sign-on-push = true;
        ui.show-cryptographic-signatures = true;
      };
    };
  };
}
