{
  lib,
  bupkes,
  config,
  ...
}:
let
  inherit (lib) mkIf;

  persistPath = string: if bupkes.host.features.impermanence then "/persistent${string}" else string;
in
{
  programs.ssh.startAgent = true;

  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };

    hostKeys = [
      {
        path = persistPath "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  users.users.${bupkes.user.username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDaLWsbY4PoUI6xKJlmuzFCCC2hpj6eIPAMiFeaH1bsa rodnelkes@amende"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHpTlwHpvrCyOBYGWYKpFM7Q0OYC8bP39gKU4jpK8AWp rodnelkes@boobookeys"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMOnFR3Mogjp+bnWYmCD/KujxtqghlXiKBXI1qsLx+Q8 rodnelkes@bingle"
  ];

  hm.programs.ssh = {
    enable = true;

    # Deprecated, will be removed
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "yes";
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

  environment.persistence."/persistent" = mkIf bupkes.host.features.impermanence {
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];

    users.${bupkes.user.username} = {
      directories = [
        {
          directory = ".ssh";
          mode = "0700";
        }
      ];
    };
  };
}
