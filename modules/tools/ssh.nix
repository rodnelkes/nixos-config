{ config, bupkes, ... }:

{
  programs.ssh.startAgent = true;

  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users.users.${bupkes.user.username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHpTlwHpvrCyOBYGWYKpFM7Q0OYC8bP39gKU4jpK8AWp rodnelkes@boobookeys"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDLJYTglmXdImiJAEzB3O5iLEGA/ckC+Jjta852RtQPj rodnelkes@bingle"
  ];

  hm = {
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
            identityFile = config.age.secrets.github.path;
          };
        };
      };

      nushell.extraConfig = builtins.readFile ./eval_ssh-agent.nu;
    };
  };
}
