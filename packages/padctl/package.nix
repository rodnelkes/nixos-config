{
  sources,
  pkgs,
  ...
}:
let
  inherit (pkgs) callPackage;
  inherit (pkgs.stdenv) mkDerivation;

  zig = pkgs.zig_0_15;
in
{
  nixpkgs.overlays = [
    (_final: _prev: {
      padctl = mkDerivation (finalAttrs: {
        pname = "padctl";
        version = "0.1.13";

        src = sources.padctl.outPath;

        deps = callPackage ./_build.zig.zon.nix {
          inherit zig;
        };

        nativeBuildInputs = with pkgs; [
          zig
          libusb1
        ];

        zigBuildFlags = [
          "--system"
          "${finalAttrs.deps}"
          "-Doptimize=ReleaseFast"
        ];

        postInstall = ''
          cp -R ./devices $out/bin
        '';

        meta.mainProgram = "padctl";
      });
    })
  ];
}
