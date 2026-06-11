{
  pkgs,
  lib,
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

  iconFiles = map (file: unsafeDiscardStringContext (removePrefix "${librewolf}/" file)) (
    listFilesRecursive "${librewolf}/share/icons"
  );
  iconSources = genAttrs' iconFiles (
    file: nameValuePair ".local/${file}" { source = "${librewolf}/${file}"; }
  );

  ns = "protonvpn";
in
{
  programs.firejail.wrappedBinaries.librewolf = {
    executable = getExe librewolf;
    desktop = "${librewolf}/share/applications/librewolf.desktop";
    profile = "${firejail}/etc/firejail/librewolf.profile";
    extraArgs = [ "--netns=${ns}" ];
  };

  hj.files = iconSources;
}
