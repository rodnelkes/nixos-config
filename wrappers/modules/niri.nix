{ types, ... }:

{
  name = "niri";

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
      inherit (inputs.nixpkgs.pkgs) symlinkJoin niri makeWrapper;

    in
    symlinkJoin {
      name = "niri-wrapped";
      paths = [ niri ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/niri \
        --set NIRI_CONFIG ${options.configPath}
      '';
      passthru.providedSessions = [ "niri" ];
      meta.mainProgram = "niri";
    };
}
