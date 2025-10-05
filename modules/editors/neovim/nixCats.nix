{
  config,
  inputs,
  ...
}:
let
  inherit (inputs.nixCats) utils;
  inherit (config.flake.homeConfigurations."rodnelkes".config.lib.file) mkOutOfStoreSymlink;

  nelvim_path = "/home/rodnelkes/nixos-config/modules/editors/neovim/nelvim";
in
{
  flake.modules.homeManager.nixCats = {
    imports = [
      inputs.nixCats.homeModule
    ];

    programs.nushell.extraConfig = ''
      $env.EDITOR = 'nvim'
    '';

    home.sessionVariables.EDITOR = "nvim";

    xdg.configFile."nvim" = {
      source = mkOutOfStoreSymlink nelvim_path;
      recursive = true;
    };

    nixCats = {
      enable = true;
      addOverlays = [
        (utils.standardPluginOverlay inputs)
      ];
      packageNames = [ "nelvim" ];

      luaPath = ./nelvim;

      categoryDefinitions.replace =
        { pkgs, ... }:
        {
          lspsAndRuntimeDeps = {
            lua = with pkgs; [
              lua-language-server
              stylua
            ];

            nix = with pkgs; [
              nixd
              nixfmt-rfc-style
            ];
          };

          startupPlugins = {
            general = with pkgs.vimPlugins; [
              lualine-nvim
              oil-nvim
              undotree
              fzf-lua
              mini-diff
              mini-git
              mini-hipatterns
              mini-icons
              mini-indentscope
              conform-nvim
              indent-blankline-nvim
              nvim-treesitter.withAllGrammars
            ];

            colorschemes = [
              {
                plugin = pkgs.vimPlugins.catppuccin-nvim;
                name = "catppuccin";
              }
            ];

            cmp = with pkgs.vimPlugins; [
              blink-cmp
              nvim-cmp
              luasnip
            ];
          };

          optionalPlugins = { };
          sharedLibraries = { };
          environmentVariables = { };
          python3.libraries = { };
          extraWrapperArgs = { };
        };

      packageDefinitions.replace = {
        nelvim =
          { pkgs, ... }:
          {
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = false;
              aliases = [
                "vi"
                "vim"
                "nvim"
              ];
              hosts = {
                python3.enable = true;
                node.enable = true;
              };
            };
            categories = {
              general = true;
              colorschemes = true;
              lua = true;
              nix = true;
              cmp = true;
            };
            extra = {
              nixdExtras = {
                nixpkgs = ''import ${pkgs.path} {}'';
                nixos_options = ''(builtins.getFlake "path:${builtins.toString inputs.self.outPath}").nixosConfigurations.boobookeys.options'';
                home_manager_options = ''(builtins.getFlake "path:${builtins.toString inputs.self.outPath}").homeConfigurations.rodnelkes.options'';
              };
            };
          };
      };
    };
  };
}
