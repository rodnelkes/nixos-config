{
  flake.modules.nixos.distributed-builds = {
    nix = {
      distributedBuilds = true;
      settings.builders-use-substitutes = true;

      buildMachines = [
        {
          hostName = "boobookeys";
          system = "x86_64-linux";
          sshUser = "remotebuild";
          sshKey = "/root/.ssh/remotebuild";
          supportedFeatures = [ "nixos-test" "big-parallel" "kvm" ];
        }
      ];
    };
  };
}
