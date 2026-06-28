_:

{
  inputs.bupkes.from = { root }: root.bupkes;

  options = {
    config.mutators = [ "/git" ];
    excludes.mutators = [ "/direnv" ];
  };

  mutations = {
    "/git".config =
      { inputs }:
      let
        inherit (inputs.bupkes) host user;
        inherit (inputs.nixpkgs.pkgs) openssh;
        inherit (inputs.nixpkgs.pkgs.lib) getExe';

        persistPath = string: if host.features.impermanence then "/persistent${string}" else string;
        signingKey = persistPath "/run/agenix/github";
        allowedSigners = persistPath "/run/agenix/allowed-signers";
      in
      {
        user = {
          inherit signingKey;

          name = user.fullName;
          email = user.email;
        };

        commit.gpgSign = true;
        tag.gpgSign = true;
        gpg = {
          format = "ssh";
          "ssh" = {
            allowedSignersFile = allowedSigners;
            program = getExe' openssh "ssh-keygen";
          };
        };
      };
  };
}
