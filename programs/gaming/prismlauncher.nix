{
  pkgs,
  ...
}:
let
  inherit (pkgs)
    prismlauncher
    javaPackages
    ;

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

  persist.user.directories = [ ".local/share/PrismLauncher" ];
}
