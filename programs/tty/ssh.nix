{
  pkgs,
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
  environment.systemPackages = [ pkgs.openssh ];

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

  hj.files.".ssh/config".text = ''
    Host github.com gitlab.com codeberg.org
      IdentitiesOnly yes
      IdentityFile ${config.age.secrets.github.path}

    Host *
      ForwardAgent no
      ServerAliveInterval 0
      ServerAliveCountMax 3
      Compression no
      AddKeysToAgent yes
      HashKnownHosts no
      UserKnownHostsFile ~/.ssh/known_hosts
      ControlMaster no
      ControlPath ~/.ssh/master-%r@%n:%p
      ControlPersist no
  '';

  persist = mkIf bupkes.host.features.impermanence {
    system.files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];

    user.directories = [
      {
        directory = ".ssh";
        mode = "0700";
      }
    ];
  };
}
