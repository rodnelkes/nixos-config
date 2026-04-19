{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  persist.user.directories = mkIf bupkes.host.features.impermanence [
    ".config/unity3d/Freehold Games/CavesOfQud"
  ];
}
