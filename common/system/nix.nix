{ sources, ... }:

{
  nix = {
    channel.enable = false;

    settings = {
      nix-path = [ "nixpkgs=${sources.nixpkgs.outPath}" ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
