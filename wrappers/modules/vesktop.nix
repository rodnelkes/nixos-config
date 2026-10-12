{ promise, ... }:

{
  inputs.nixpkgs.from = { root }: root.nixpkgs;

  result = promise (
    { inputs }:
    let
      inherit (inputs.nixpkgs.pkgs) symlinkJoin vesktop makeWrapper;
    in
    symlinkJoin {
      name = "vesktop-wrapped";
      paths = [ vesktop ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/vesktop
      '';
      meta.mainProgram = "vesktop";
    }
  );
}
