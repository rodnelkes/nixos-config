_:

{
  options = {
    configPaths.mutators = [
      "/catppuccin"
      "/starship"
      "/nushell"
      "/direnv"
    ];
  };

  mutations = {
    "/nushell".configPaths = [ ./config.nu ];
  };
}
