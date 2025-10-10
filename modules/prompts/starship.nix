{
  config,
  ...
}:
let
  inherit (builtins)
    fetchurl
    readFile
    fromTOML
    replaceStrings
    map
    ;
  inherit (config.flake.nixosConfigurations.boobookeys.lib) foldl recursiveUpdate;

  jetpackConfig = fromTOML (
    readFile (fetchurl {
      url = "https://raw.githubusercontent.com/starship/starship/6526d4bb5e26443f78992db38c8a2fd0154002cb/docs/public/presets/toml/jetpack.toml";
      sha256 = "4957188eeb0018d68f3fa77e1a53a8134263e221cc2db02a575bcedf85c97403";
    })
  );

  starshipJJModule = {
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

  gitModules = [
    "branch"
    "commit"
    "state"
    "metrics"
    "status"
  ];

  starshipGitModule = module: {
    custom."git_${module}" = {
      when = "! jj --ignore-working-copy root";
      command = "starship module git_${module}";
      style = "";
    };
    "git_${module}".disabled = true;
  };

  # Maybe not needed?
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
    inherit (jetpackConfig) format right_format;
  } gitModules;
in
{
  flake.modules.homeManager.starship = {
    programs.starship = {
      enable = true;

      settings = foldl recursiveUpdate jetpackConfig (
        [
          starshipJJModule
          starshipFormatModule
        ]
        ++ map starshipGitModule gitModules
      );
    };
  };
}
