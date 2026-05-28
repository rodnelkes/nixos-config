{
  sources,
  ...
}:
let
  nix-minecraft = import sources.nix-minecraft;
in
{
  imports = [ nix-minecraft.nixosModules.minecraft-servers ];

  nixpkgs.overlays = [ nix-minecraft.overlay ];
}
