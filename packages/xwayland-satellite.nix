{ pkgs, ... }:
let
  inherit (pkgs) fetchFromGitHub;
in
{
  nixpkgs.overlays = [
    (_final: prev: {
      xwayland-satellite = prev.xwayland-satellite.overrideAttrs (
        finalAttrs: _prevAttrs: {
          version = "0.8.1";

          src = fetchFromGitHub {
            owner = "Supreeeme";
            repo = "xwayland-satellite";
            tag = "v${finalAttrs.version}";
            hash = "sha256-BUE41HjLIGPjq3U8VXPjf8asH8GaMI7FYdgrIHKFMXA=";
          };

          cargoDeps = prev.rustPlatform.fetchCargoVendor {
            inherit (finalAttrs) pname version src;
            hash = finalAttrs.cargoHash;
          };

          cargoHash = "sha256-16L6gsvze+m7XCJlOA1lsPNELE3D364ef2FTdkh0rVY=";
        }
      );
    })
  ];
}
