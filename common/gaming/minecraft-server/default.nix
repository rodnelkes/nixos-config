{
  sources,
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (builtins)
    attrValues
    fromJSON
    mapAttrs
    readFile
    ;
  inherit (pkgs)
    javaPackages
    fabricServers
    linkFarmFromDrvs
    fetchurl
    ;
  inherit (lib) mkIf;

  nix-minecraft = import sources.nix-minecraft;
  java = javaPackages.compiler.temurin-bin.jre-25;
in
{
  imports = [ nix-minecraft.nixosModules.minecraft-servers ];

  nixpkgs.overlays = [ nix-minecraft.overlay ];

  networking.firewall.allowedUDPPorts = [ 19132 ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.fabric = {
      enable = true;
      autoStart = false;

      package = fabricServers.fabric-26_2.override {
        loaderVersion = "0.19.5";
        jre_headless = java;
      };

      jvmOpts = "-Xms8G -Xmx8G -XX:+UseZGC -XX:+UseCompactObjectHeaders";

      serverProperties = {
        difficulty = "hard";
        gamemode = "survival";
        simulation-distance = 8;
        spawn-protection = 0;
        view-distance = 16;
        white-list = true;
      };

      whitelist = {
        Rodnelkes = "dd134f98-275a-40cb-be40-ae9e157b37da";
        ".UnicornYoshi155" = "00000000-0000-0000-0009-01f83e2de3fa";
        ".RivalVeil955502" = "00000000-0000-0000-0009-01f24bbedebb";
        ".Rodnelkes" = "00000000-0000-0000-0009-01f4fd4c76dd";
      };

      operators = {
        Rodnelkes = {
          uuid = "dd134f98-275a-40cb-be40-ae9e157b37da";
          level = 4;
          bypassesPlayerLimit = true;
        };
      };

      symlinks.mods = linkFarmFromDrvs "mods" (
        attrValues (mapAttrs (_: value: fetchurl value) (fromJSON (readFile ./mods.json)))
      );

      files."config/Geyser-Fabric/config.yml".value = {
        java.auth-type = "floodgate";
      };
    };
  };

  persist.system.directories = mkIf bupkes.host.features.impermanence [
    {
      directory = "/srv/minecraft";
      user = "minecraft";
      group = "minecraft";
      mode = "0770";
    }
  ];
}
