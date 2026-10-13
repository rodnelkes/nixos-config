{ inputs }:
let
  inherit (inputs.nixpkgs.pkgs) callPackage;

  kdl-lsp = callPackage ./kdl-lsp.nix { inherit inputs; };
in
with inputs.nixpkgs.pkgs;
[
  # bash
  bash-language-server
  shfmt

  # c/c++
  clang-tools

  # kdl
  kdl-lsp
  kdlfmt

  # lua
  lua-language-server
  stylua

  # nix
  nixd
  nixfmt

  # nu
  nushell
  nufmt

  # python
  basedpyright
  ruff

  # qml
  kdePackages.qtdeclarative

  # yaml
  yaml-language-server
  yamlfmt
]
