_:

{
  inputs = {
    nixpkgs.path = "/nixpkgs";
  };

  mutations = {
    "/nushell".configPaths =
      { inputs }:
      let
        inherit (inputs.nixpkgs.pkgs) writeText direnv;
        inherit (inputs.nixpkgs.lib) getExe;

        config =
          writeText "direnv-nushell-config"
            # nu
            ''
              # https://www.nushell.sh/cookbook/direnv.html#configuring-direnv-in-nushell
              use std/config *

              # Initialize the PWD hook as an empty list if it doesn't exist
              $env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

              $env.config.hooks.env_change.PWD ++= [{||
                if (which direnv | is-empty) {
                  # If direnv isn't installed, do nothing
                  return
                }

                ${getExe direnv} export json | from json | default {} | load-env
                # If direnv changes the PATH, it will become a string and we need to re-convert it to a list
                $env.PATH = do (env-conversions).path.from_string $env.PATH
              }]
            '';
      in
      [ config ];

    "/git".excludes = _: ".envrc";
  };
}
