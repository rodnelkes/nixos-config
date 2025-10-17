{
  config,
  ...
}:
let
  homeConfig = config.flake.homeConfigurations.rodnelkes.config;
in
{
  flake.modules = {
    nixos.ssh = {
      programs.ssh.startAgent = true;
      services.openssh.enable = true;
    };

    homeManager.ssh = {
      programs = {
        ssh = {
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

            "git" = {
              host = "github.com gitlab.com";
              identitiesOnly = true;
              identityFile = homeConfig.sops.secrets.github.path;
            };
          };
        };

        nushell.extraConfig = builtins.readFile ./eval_ssh-agent.nu;
      };
    };
  };
}
