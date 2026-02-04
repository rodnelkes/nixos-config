_:

{
  options = {
    config.mutators = [ "/starship" ];
  };

  mutations = {
    "/nushell".configPaths =
      { inputs }:
      let
        inherit (inputs.nixpkgs.pkgs) writeText runCommand starship;
        inherit (inputs.nixpkgs.lib) getExe;

        config = writeText "starship-nushell-config" ''
          use ${
            runCommand "starship-nushell-config.nu" { } ''
              ${getExe starship} init nu >> "$out"
            ''
          }
        '';
      in
      [ config ];

    "/starship".config =
      { inputs }:
      let
        inherit (builtins) readFile replaceStrings;
        inherit (inputs.nixpkgs.lib) foldl recursiveUpdate;
        inherit (inputs.sources.default) starship;

        starshipJetpackModule = fromTOML (
          readFile "${starship.outPath}/docs/public/presets/toml/jetpack.toml"
        );

        gitModules = [
          "branch"
          "commit"
          "state"
          "metrics"
          "status"
        ];

        # Disables jetpack git modules in favor of custom git modules provided by jujutsu. This may not be needed.
        renameFormat =
          module: string: replaceStrings [ "$git_${module}" ] [ "\${custom.git_${module}}" ] string;

        renameFormats =
          formatAttrs: module:
          formatAttrs
          // (
            if module == "metrics" then
              { format = renameFormat module formatAttrs.format; }
            else
              { right_format = renameFormat module formatAttrs.right_format; }
          );

        starshipFormatModule = foldl renameFormats {
          inherit (starshipJetpackModule) format right_format;
        } gitModules;

        starshipJujutsuModule = {
          custom.jj = {
            when = "jj --ignore-working-copy root";
            symbol = " ";
            command = # sh
              ''
                jj log --revisions @ --no-graph --ignore-working-copy --color always --limit 1 --template '
                  separate(" ",
                    change_id.shortest(8),
                    bookmarks,
                    concat(
                      if(conflict, "conflict"),
                      if(divergent, "divergent"),
                      if(hidden, "hidden"),
                      if(immutable, "immutable"),
                    ),
                    raw_escape_sequence("\x1b[1;32m") ++ if(empty, "(empty)"),
                    raw_escape_sequence("\x1b[1;32m") ++ coalesce(
                      truncate_end(29, description.first_line(), "…"),
                      "(no description set)",
                    ) ++ raw_escape_sequence("\x1b[0m"),
                  )
                '
              '';
          };
        };

        mkStarshipGitModule = module: {
          custom."git_${module}" = {
            when = "! jj --ignore-working-copy root";
            command = "starship module git_${module}";
            style = "";
          };
          "git_${module}".disabled = true;
        };
      in
      foldl recursiveUpdate starshipJetpackModule (
        [
          starshipFormatModule
          starshipJujutsuModule
        ]
        ++ map mkStarshipGitModule gitModules
      );
  };
}
