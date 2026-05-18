{ bupkes }:

hostVars:
let
  applyPath = localPath: (/. + "/${bupkes.host.configDirectory}/${localPath}");

  modules = [
    "packages"
    "system"
    "hosts/${hostVars.hostname}"
  ]
  ++ map (feature: "programs/${feature}") hostVars.features.modules;
in
map applyPath modules
