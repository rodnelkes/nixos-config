configDirectory: hostVars:
let
  applyPath = localPath: (/. + "/${configDirectory}/${localPath}");

  modules = [
    "system"
    "hosts/${hostVars.hostname}"
  ]
  ++ map (feature: "programs/${feature}") hostVars.features.modules;
in
map applyPath modules
