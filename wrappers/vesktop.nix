{ types, promise, ... }:

{
  inputs = {
    mkWrapper.from = { root }: root.mkWrapper;
    nixpkgs.from = { root }: root.nixpkgs;
  };

  options = {
    package = {
      type = types.derivation;
      default = promise ({ inputs }: inputs.nixpkgs.pkgs.vesktop);
      description = "The vesktop package to be wrapped.";
    };
  };

  result = promise (
    { options, inputs }:
    inputs.mkWrapper {
      inherit (options) package;
    }
  );
}
