{
  sources,
  pkgs,
  bupkes,
  ...
}:
let
  inherit (builtins) readFile;
  inherit (pkgs.rustPlatform) buildRustPackage;
  inherit (pkgs.vimUtils) buildVimPlugin;

  nelvim_path = "${bupkes.host.configDirectory}/modules/editors/neovim/nelvim";
  mnw = import sources.mnw;

  kdlSrc = sources.kdl-rs.outPath;
  kdlLspCargoTOML = fromTOML (readFile "${kdlSrc}/tools/kdl-lsp/Cargo.toml");
  kdl-lsp = buildRustPackage {
    pname = kdlLspCargoTOML.package.name;
    version = kdlLspCargoTOML.package.version;
    cargoLock.lockFile = "${kdlSrc}/Cargo.lock";
    src = kdlSrc;
    cargoBuildFlags = [ "-p kdl-lsp" ];
  };

  jj-diffconflicts = buildVimPlugin {
    name = "jj-diffconflicts";
    src = sources.jj-diffconflicts.outPath;
  };

  nelvim = mnw.lib.wrap pkgs {
    appName = "nelvim";

    aliases = [
      "vi"
      "vim"
    ];

    initLua = ''require("nelvim")'';

    extraBinPath = with pkgs; [
      # bash
      bash-language-server
      shfmt

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
      bupkes.wrappers.nushell.drv
      nufmt

      # qml
      kdePackages.qtdeclarative

      # yaml
      yaml-language-server
      yamlfmt
    ];

    plugins = {
      start = with pkgs.vimPlugins; [
        # general
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
        blink-nerdfont-nvim
        jj-nvim
        jj-diffconflicts

        # treesitter
        (nvim-treesitter.withPlugins (
          p: with p; [
            bash
            nu
            kdl
            lua
            nix
            qmljs
            yaml
          ]
        ))

        # colorschemes
        catppuccin-nvim

        # cmp
        blink-cmp
        nvim-cmp
        luasnip
      ];

      dev.nelvim = {
        pure = ./nelvim;
        impure = nelvim_path;
      };
    };
  };
in
{
  environment.systemPackages = [ nelvim.devMode ];
}
