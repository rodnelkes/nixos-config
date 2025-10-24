{ sources, ... }:

let
  inherit (builtins) fetchGit substring;

  # This is only needed because (import sources.lix).lastModifiedDate is "19700101000000"
  # Not sure why, maybe fault lies with npins?
  lixInfo =
    if (import sources.lix).lastModifiedDate == "19700101000000" then
      let
        lixRepo = sources.lix.repository;
        lixUrl = "${lixRepo.server}/${lixRepo.owner}/${lixRepo.repo}";
      in
      fetchGit {
        url = lixUrl;
        ref = sources.lix.branch;
        rev = sources.lix.revision;
      }
    else
      (import sources.lix) // { shortRev = substring 0 7 sources.lix.revision; };
in
{
  imports = [
    (import "${sources.lix-nixos-module}/module.nix" {
      lix = sources.lix.outPath;

      versionSuffix = "pre${substring 0 8 lixInfo.lastModifiedDate}-${lixInfo.shortRev}";
    })
  ];
}
