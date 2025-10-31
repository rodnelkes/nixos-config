{ config, bupkes, ... }:

{
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
