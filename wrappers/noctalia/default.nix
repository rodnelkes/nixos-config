{ types, ... }:

{
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
  };
}
