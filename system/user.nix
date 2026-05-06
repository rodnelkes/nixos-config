{ config, bupkes, ... }:
let
  inherit (bupkes.lib) mkSecret;
in
{
  age.secrets = mkSecret "user_password" "0400" bupkes.user.username;

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  users = {
    mutableUsers = false;

    users.${bupkes.user.username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPasswordFile = config.age.secrets.user_password.path;
    };
  };
}
