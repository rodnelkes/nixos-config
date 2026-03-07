{ sources, ... }:

{
  nix = {
    nixPath = [ "nixpkgs=${sources.nixpkgs.outPath}" ];

    channel.enable = false;

    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
