{
  services = {
    radarr = {
      enable = true;
      openFirewall = true;

      settings.server.urlbase = "/radarr";
    };

    nginx.virtualHosts."rod.nelk.es".locations."/radarr/".proxyPass =
      "http://192.168.99.1:7878/radarr/";
  };

  persist.system.directories = [ "/var/lib/radarr" ];
}
