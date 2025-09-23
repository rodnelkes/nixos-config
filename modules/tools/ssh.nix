{
  flake.modules.homeManager.ssh = {
    programs.ssh = {
      enable = true;

      matchBlocks = {
        "github.com" = {
          identityFile = "~/.ssh/github";
        };
      };
    };
  };
}
