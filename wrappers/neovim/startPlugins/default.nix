{ inputs }:
let
  inherit (inputs.nixpkgs.pkgs) callPackage vimPlugins;
in
{
  jj-diffconflicts = callPackage ./jj-diffconflicts.nix { inherit inputs; };

  inherit (vimPlugins)
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

    # colorschemes
    catppuccin-nvim

    # cmp
    blink-cmp
    nvim-cmp
    luasnip
    ;
}
