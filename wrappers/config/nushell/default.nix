_:

{
  options = {
    configPaths.mutators = [
      "/catppuccin"
      "/starship"
      "/nushell"
      "/ssh"
    ];
  };

  mutations = {
    "/nushell".configPaths = _: [ ./config.nu ];
  };
}
