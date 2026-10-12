{ bupkes }:

hostVars:
let
  applyPath = localPath: (/. + "/${bupkes.host.configDirectory}/${localPath}");

  modules = [
    "packages"
    "hosts/${hostVars.hostname}"
  ]
  ++ map (feature: "modules/${feature}") hostVars.features.modules;
in
map applyPath modules
