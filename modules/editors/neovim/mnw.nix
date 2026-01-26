{
  sources,
  pkgs,
  bupkes,
  ...
}:
let
  nelvim_path = "${bupkes.host.configDirectory}/modules/editors/neovim/nelvim";
  mnw = import sources.mnw;

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

      # lua
      lua-language-server
      stylua

      # nix
      nixd
      nixfmt
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

        # treesitter
        (nvim-treesitter.withPlugins (
          p: with p; [
            bash
            nu
            lua
            nix
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
