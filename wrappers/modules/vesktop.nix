_:

{
  inputs = {
    nixpkgs.path = "/nixpkgs";
  };

  impl =
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
    };
}
