{
  flake.modules.nixos.nix-settings = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
