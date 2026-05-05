{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  persist.user.directories = mkIf bupkes.host.features.impermanence [ ".config/StardewValley" ];

  # This fixes multiplayer when running on native linux:
  # http://forums.stardewvalley.net/threads/galaxy-api-not-loading-with-glibc-2-41.36974/post-173903
  # nix-shell -p prelink
  # cd `~/.steam/steam/steamapps/common/Stardew Valley/`
  # execstack -c libGalaxy64.so && execstack -c libGalaxyCSharpGlue.so
}
