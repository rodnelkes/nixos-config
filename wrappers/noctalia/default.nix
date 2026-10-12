{ types, promise, ... }:

{
  inputs = {
    sources.from = { parent }: parent.sources;
  };

  options = {
    configFile.default = ./settings.toml;
    wallpapers = {
      type = types.listOf types.pathLike;
      default = [ ./BladeOfMiquella-mocha-nearest-neighbor.png ];
    };
    facePath = {
      type = types.pathLike;
      default = ./face.png;
    };
    package.default = promise (
      { inputs }: (import inputs.sources.noctalia { inherit (inputs.nixpkgs) pkgs; }).package
    );
  };
}
