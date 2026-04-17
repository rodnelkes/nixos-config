{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.gale ];

  persist.user.directories = [
    ".cache/com.kesomannen.gale"
    ".config/com.kesomannen.gale"
    ".local/share/com.kesomannen.gale"
  ];
}
