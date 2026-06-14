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
    ;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (bupkes.host.features) netns;

  iconFiles = map (file: unsafeDiscardStringContext (removePrefix "${librewolf}/" file)) (
    listFilesRecursive "${librewolf}/share/icons"
  );
  iconSources = genAttrs' iconFiles (
    file: nameValuePair ".local/${file}" { source = "${librewolf}/${file}"; }
  );
in
{
  programs.firejail.wrappedBinaries.librewolf = {
    executable = getExe librewolf;
    desktop = "${librewolf}/share/applications/librewolf.desktop";
    profile = "${firejail}/etc/firejail/librewolf.profile";
    extraArgs = [ "--netns=${netns}" ];
  };

  hj.files = iconSources;
}
