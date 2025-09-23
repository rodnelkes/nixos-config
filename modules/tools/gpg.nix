{
  flake.modules.homeManager.gpg = { pkgs, ... }: {
    programs.gpg.enable = true;

    home.packages = with pkgs; [
      pinentry-tty
    ];

    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-tty;

      enableNushellIntegration = true;
    };
  };
}
