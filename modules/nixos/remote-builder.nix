{
  flake.modules.nixos.remote-builder = {
    users = {
      users.remotebuild = {
        isNormalUser = true;
        createHome = false;
        group = "remotebuild";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJhLHp4cWPF+X1lBxzJXq7RFMGjM8/r580g4MEKqkz2S root@boobookeys"
        ];
      };

      groups.remotebuild = { };
    };

    nix.settings.trusted-users = [ "remotebuild" ];
  };
}
