{
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (builtins) unsafeDiscardStringContext;
  inherit (pkgs) librewolf firejail;
  inherit (lib)
    removePrefix
    genAttrs'
    nameValuePair
    getExe
    mkIf
    ;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (bupkes.host.features.vpn) splitTunneling;

  iconFiles = map (file: unsafeDiscardStringContext (removePrefix "${librewolf}/" file)) (
    listFilesRecursive "${librewolf}/share/icons"
  );
  iconSources = genAttrs' iconFiles (
    file: nameValuePair ".local/${file}" { source = "${librewolf}/${file}"; }
  );
in
{
  config = mkIf splitTunneling {
    programs.firejail.wrappedBinaries.librewolf = {
      executable = getExe librewolf;
      desktop = "${librewolf}/share/applications/librewolf.desktop";
      profile = "${firejail}/etc/firejail/librewolf.profile";
      extraArgs = [ "--netns=vpn" ];
    };

    hj.files = iconSources;
  };
}
