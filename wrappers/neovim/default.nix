{ promise, ... }:

{
  inputs = {
    sources.from = { parent }: parent.sources;
  };

  options = {
    initLuaFile.default = ./init.lua;

    aliases.default = [
      "vi"
      "vim"
    ];

    extraPackages.default = promise (import ./extraPackages);
    startPlugins.default = promise (import ./startPlugins);
    devPlugins.default = [ (toString ./nvim) ];
    treesitterPackage.default = promise (
      { inputs }: inputs.nixpkgs.pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    );
  };

  mutations = {
    "/jujutsu".settings = {
      ui.merge-editor = "diffconflicts";
      merge-tools.diffconflicts = {
        program = "nvim";
        merge-args = [
          "-c"
          "let g:jj_diffconflicts_marker_length=$marker_length"
          "-c"
          "JJDiffConflicts!"
          "$output"
          "$base"
          "$left"
          "$right"
        ];
        merge-tool-edits-conflict-markers = true;
      };
    };
  };
}
