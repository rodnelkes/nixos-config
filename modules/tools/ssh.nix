{
  flake.modules = {
    nixos.ssh = {
      services.openssh.enable = true;
    };

    homeManager.ssh = {
      programs.ssh = {
        enable = true;

        # Deprecated, will be removed
        enableDefaultConfig = false;

        matchBlocks = {
          "*" = {
            forwardAgent = false;
            addKeysToAgent = "no";
            compression = false;
            serverAliveInterval = 0;
            serverAliveCountMax = 3;
            hashKnownHosts = false;
            userKnownHostsFile = "~/.ssh/known_hosts";
            controlMaster = "no";
            controlPath = "~/.ssh/master-%r@%n:%p";
            controlPersist = "no";
          };

          "github.com" = {
            identityFile = "~/.ssh/github";
          };
        };
      };
    };
  };
}
