_:

{
  options = {
    sourceFiles.mutators = [
      "/catppuccin"
      "/starship"
      "/nushell"
      "/direnv"
    ];
  };

  mutations = {
    "/nushell".sourceFiles = [ ./config.nu ];
  };
}
