{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.pinentry-tty ];

  hm = {
    programs.gpg.enable = true;

    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-tty;

      enableNushellIntegration = true;
    };
  };
}
