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

  java = javaPackages.compiler.temurin-bin.jre-25;
in
{
  environment.systemPackages = [
    (prismlauncher.override {
      additionalLibs = with pkgs; [
        ocl-icd
        khronos-ocl-icd-loader
      ];
      jdks = [
        java
      ];
    })
  ];

  persist.user.directories = mkIf bupkes.host.features.impermanence [ ".local/share/PrismLauncher" ];
}
