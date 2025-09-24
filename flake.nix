{
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      type = "github";
      owner = "nix-community";
      repo = "NixOS-WSL";
      ref = "main";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";

      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree = {
      type = "github";
      owner = "vic";
      repo = "import-tree";
    };

    treefmt-nix = {
      type = "github";
      owner = "numtide";
      repo = "treefmt-nix";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-file = {
      type = "github";
      owner = "vic";
      repo = "flake-file";
    };

    nixos-facter-modules = {
      type = "github";
      owner = "nix-community";
      repo = "nixos-facter-modules";
    };

    agenix = {
      type = "github";
      owner = "ryantm";
      repo = "agenix";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        darwin.follows = "";
      };
    };

    agenix-rekey = {
      type = "github";
      owner = "oddlama";
      repo = "agenix-rekey";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    catppuccin = {
      type = "github";
      owner = "catppuccin";
      repo = "nix";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats = {
      type = "github";
      owner = "BirdeeHub";
      repo = "nixCats-nvim";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      inputs.import-tree [
        ./hosts
        ./modules
      ]
    );
}
