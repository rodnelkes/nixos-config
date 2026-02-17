_:

{
  name = "noctalia-shell";

  inputs = {
    nixpkgs.path = "/nixpkgs";
  };

  impl =
    { inputs }:
    let
      inherit (inputs.nixpkgs.pkgs) symlinkJoin noctalia-shell makeWrapper;
    in
    symlinkJoin {
      name = "noctalia-shell-wrapped";
      paths = [ noctalia-shell ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/noctalia-shell
      '';
      meta.mainProgram = "noctalia-shell";
    };
}
