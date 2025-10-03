{
  inputs,
  ...
}:
{
  flake.modules = {
    nixos.sops-nix = {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      sops = {
        defaultSopsFile = ../../secrets.yaml;
        
        age = {
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          keyFile = "/var/lib/sops-nix/key.txt";
          generateKey = true;
        };

        secrets = {
          rodnelkes_password = {};
        };
      };
    };

    homeManager.sops-nix = {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
      ];

      sops = {
        defaultSopsFile = ../../secrets.yaml;

        age.keyFile = "/home/rodnelkes/.config/sops/age/keys.txt";

        secrets = {
          github = {};
        };
      };
    };
  };
}
