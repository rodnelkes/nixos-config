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

      package = fabricServers.fabric-26_1_2.override {
        loaderVersion = "0.19.2";
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
          url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/E1mjhYMF/fabric-api-0.150.0%2B26.1.2.jar";
          sha512 = "238c793b720ed21d2d5b564eca88c714cf2188f7b0fb1fd30864660f80901e2b4dad273994b6f77de3c0aa365f930ed8aaccffac49b36c6456b153b52d5d21dc";
        };

        "Cloth Config API" = fetchurl {
          url = "https://cdn.modrinth.com/data/9s6osm5g/versions/GFM8zh9J/cloth-config-26.1.154.jar";
          sha512 = "8bfb75f2cac0a9910316c6a368a228c0f8f1261ac6f03dec5fba594e1619ac04334a3df4fb29778d61d0b8290d55949371a523d722b35501bf9a2902956d3b17";
        };

        Geyser = fetchurl {
          url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/YxMEEm35/Geyser-Fabric-2.10.0-b1162.jar";
          sha512 = "0ea805b2c55aea0236a1ea9520e295eed7d996d2765023566736a3d9e851d77bdb98c68e7e431db569a0ba2c6d96e75d98b9f39a8d5ca354dd470357abce6d9f";
        };

        Floodgate = fetchurl {
          url = "https://cdn.modrinth.com/data/bWrNNfkb/versions/fD4J9lnX/Floodgate-Fabric-2.2.6-b63.jar";
          sha512 = "54874033236df688da15fd4dd7d2d99d002e8955cb2d788d5ba409d753eb17629f53a6e976992de8cca8c8dd3663c70b283da88b5a12d72cef9647d09e04ae62";
        };

        "No Chat Reports" = fetchurl {
          url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/2yrLNE3S/NoChatReports-FABRIC-26.1-v2.19.0.jar";
          sha512 = "94d58a1a4cde4e3b1750bdf724e65c5f4ff3436c2532f36a465d497d26bf59f5ac996cddbff8ecdfed770c319aa2f2dcc9c7b2d19a35651c2a7735c5b2124dad";
        };

        "Voxy WorldGen" = fetchurl {
          url = "https://cdn.modrinth.com/data/xT0lnNE9/versions/tRiQxKkc/Voxy%20World%20Gen%20V2-26.1.2-2.2.4.jar";
          sha512 = "f8d3e96c5bda4f04faa79c1731379b8217dc7a392cc208dc3d25a8dbeab790430e869705bdb4d154a359b0e1e415b12442b4e6757b002193ebb4cfbed1f2639a";
        };

        SeeU = fetchurl {
          url = "https://cdn.modrinth.com/data/coyNPDey/versions/4oChd41k/seeu-fabric-0.6.jar";
          sha512 = "8a0e3d8078ea7e682781e52bb52a0f39a8e3faa3c4bffdf7dccc550212eb11160db18df49cc57c6d15a07040572f885b0a52ea590703befe454609027050b3a5";
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
