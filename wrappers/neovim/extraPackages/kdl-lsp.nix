{ inputs, rustPlatform }:
let
  inherit (builtins) readFile;

  kdlSrc = inputs.sources.kdl-rs.outPath;
  kdlLspCargoTOML = fromTOML (readFile "${kdlSrc}/tools/kdl-lsp/Cargo.toml");
in
rustPlatform.buildRustPackage {
  pname = kdlLspCargoTOML.package.name;
  version = kdlLspCargoTOML.package.version;
  cargoLock.lockFile = "${kdlSrc}/Cargo.lock";
  src = kdlSrc;
  cargoBuildFlags = [ "-p kdl-lsp" ];
}
