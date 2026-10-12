{
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (pkgs)
    prismlauncher
    javaPackages
    ;
  inherit (lib) mkIf;
in
{
  environment.systemPackages = [
    (prismlauncher.override {
      additionalLibs = with pkgs; [
        ocl-icd
        khronos-ocl-icd-loader
      ];
      jdks = [
        javaPackages.compiler.temurin-bin.jre-21
        javaPackages.compiler.temurin-bin.jre-25
      ];
    })
  ];

  persist.user.directories = mkIf bupkes.host.features.impermanence [ ".local/share/PrismLauncher" ];
}
