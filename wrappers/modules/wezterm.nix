{ types, ... }:

{
  name = "wezterm";

  inputs = {
    nixpkgs.path = "/nixpkgs";
  };

  options = {
    configPath = {
      type = types.pathLike;
    };
  };

  impl =
    { inputs, options }:
    let
      inherit (inputs.nixpkgs.pkgs) symlinkJoin wezterm makeWrapper;

    in
    symlinkJoin {
      name = "wezterm-wrapped";
      paths = [ wezterm ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        mkdir -p $out/wezterm
        ln -sf ${options.configPath} $out/wezterm/wezterm.lua
        wrapProgram $out/bin/wezterm \
        --set WEZTERM_CONFIG_DIR $out/wezterm \
        --set WEZTERM_CONFIG_FILE $out/wezterm/wezterm.lua
      '';
      meta.mainProgram = "wezterm";
    };
}
