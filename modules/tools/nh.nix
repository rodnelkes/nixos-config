{
  flake.modules.homeManager.nh = {
    home.sessionVariables.NH_FLAKE = "/home/rodnelkes/nixos-config";

    programs = {
      nushell = {
        extraConfig = ''
          $env.NH_FLAKE = '/home/rodnelkes/nixos-config'
        '';
      };

      nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs =  "--keep-since 7d --keep 10";
        };
      };
    };
  };
}
