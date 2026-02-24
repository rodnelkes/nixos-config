_:

{
  inputs = {
    bupkes.path = "/bupkes";
  };

  options = {
    config.mutators = [ "/jujutsu" ];
  };

  mutations = {
    "/jujutsu".config =
      { inputs }:
      let
        inherit (inputs.bupkes) host user;
        inherit (inputs.nixpkgs) lib pkgs;

        persist = string: "/persistent${string}";

        signingKeyPath = "/run/agenix/github";
        signingKey = if host.hostname == "bingle" then persist signingKeyPath else signingKeyPath;

        allowedSignersPath = "/run/agenix/allowed-signers";
        allowedSigners =
          if host.hostname == "bingle" then persist allowedSignersPath else allowedSignersPath;
      in
      {
        user = {
          name = user.fullName;
          email = user.email;
        };

        signing = {
          behavior = "own";
          backend = "ssh";
          key = signingKey;

          backends.ssh = {
            allowed-signers = allowedSigners;
            program = lib.getExe' pkgs.openssh "ssh-keygen";
          };
        };
        git.sign-on-push = true;
        ui.show-cryptographic-signatures = true;

        snapshot.max-new-file-size = 39489754;

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

        remotes.origin.auto-track-bookmarks = "*";
      };
  };
}
