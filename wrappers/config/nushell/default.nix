_:

{
  options = {
    configPaths.mutators = [
      "/catppuccin"
      "/starship"
      "/nushell"
    ];
  };

  mutations = {
    "/nushell".configPaths = _: [ ./config.nu ];
  };
}
