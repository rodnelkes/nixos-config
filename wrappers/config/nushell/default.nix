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
    "/nushell".configPaths = _: [ ./config.nu ];
  };
}
