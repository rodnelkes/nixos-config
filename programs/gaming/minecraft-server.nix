{
  sources,
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (builtins) attrValues;
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
        loaderVersion = "0.19.3";
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
      };

      operators = {
        Rodnelkes = {
          uuid = "dd134f98-275a-40cb-be40-ae9e157b37da";
          level = 4;
          bypassesPlayerLimit = true;
        };
      };

      symlinks.mods = linkFarmFromDrvs "mods" (attrValues {
        "Fabric API" = fetchurl {
          url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/lVXlbH4w/fabric-api-0.155.2%2B26.2.jar";
          sha512 = "cc56984378a27c5bcd56374d6ffbb27a45c6bf3355add2ac6be9817ccac5854362249bf9d0147eb271a70fda2716129204e240d53c9aa876a2a7861f4c7f880f";
        };

        "Cloth Config API" = fetchurl {
          url = "https://cdn.modrinth.com/data/9s6osm5g/versions/Nv3xnWXd/cloth-config-26.2.155.jar";
          sha512 = "37b1e402f0df5a383656e21a38ee18cdd15cb4ba3fb62fbeba82ef4b959a4479fc32718ac0d9d154a7d9104c5f7315bfa67dbeced0b8ff240b8039d4848d5df1";
        };

        Geyser = fetchurl {
          url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/drSIg1Is/Geyser-Fabric-2.11.0-b1203.jar";
          sha512 = "d1557187220051303c957c0d813fd307bd5b3da32d68ac3572609b6db30c4a607fec06c6e6fbbb1fd295934c91080190fbe78f88b7c50cb02f38f26878f2d422";
        };

        Floodgate = fetchurl {
          url = "https://cdn.modrinth.com/data/bWrNNfkb/versions/urOFTrVX/Floodgate-Fabric-2.2.6-b67.jar";
          sha512 = "d6ecacfbf1c31171317792783754c4f58414508a8fd1aa23b9e3da5da9fe450a6e6e882e39e862cb5f1df38d2d97be8465a39857fe4b78c1cf89934230a71205";
        };

        "No Chat Reports" = fetchurl {
          url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/uiY9tUaj/NoChatReports-FABRIC-26.2-v2.20.1.jar";
          sha512 = "139dd09e04cc66fe4745264ddfbe3249be6e956326c931eb9707f9a640bbc011a4f1fd5684d04ca90e1b473be55772b0279e5c2f935c2f2e85d054e2ab0a6923";
        };

        "Voxy WorldGen" = fetchurl {
          url = "https://cdn.modrinth.com/data/xT0lnNE9/versions/II0QK5sq/Voxy%20World%20Gen%20V2-fabric-26.2-2.4.2.jar";
          sha512 = "c825eb3ccc127753fba4e34ec14dc52541b6a8fe78b29e4af796c4177614caf5a4d85bad12cd354ccaeae315420d67912155cf345b0cdb5aedfc3a8286ac5b1d";
        };

        SeeU = fetchurl {
          url = "https://cdn.modrinth.com/data/coyNPDey/versions/gyNWLCPb/seeu-fabric-0.7.2.jar";
          sha512 = "73a9532975b1d1f7a05a4773f5e68e06b902c93f2ae45814e11117d825206b0e22f9d2ff1b67068256d1efe327506cc106c5994278c0504befeaf2401f2fc9cc";
        };
      });

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
