_:

{
  options = {
    config.mutators = [ "/git" ];
    excludes.mutators = [ "/direnv" ];
  };

  mutations = {
    "/git".config =
      { inputs }:
      let
        inherit (inputs.nixpkgs.pkgs) openssh;
        inherit (inputs.nixpkgs.pkgs.lib) getExe';
      in
      {
        user = {
          signingKey = "/persistent/run/agenix/github";

          name = "Zayen Yusuf";
          email = "rodnelkes";
        };

        commit.gpgSign = true;
        tag.gpgSign = true;
        gpg = {
          format = "ssh";
          "ssh" = {
            allowedSignersFile = "/persistent/run/agenix/allowed-signers";
            program = getExe' openssh "ssh-keygen";
          };
        };
      };
  };
}
