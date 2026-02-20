{ types, ... }:

{
  name = "noctalia-shell";

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
      inherit (inputs.nixpkgs.pkgs) symlinkJoin noctalia-shell makeWrapper;
    in
    symlinkJoin {
      name = "noctalia-shell-wrapped";
      paths = [ noctalia-shell ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/noctalia-shell \
        --set NOCTALIA_SETTINGS_FILE ${options.configPath}
      '';
      meta.mainProgram = "noctalia-shell";
    };
}
