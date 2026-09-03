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
        commit.gpgSign = true;
        tag.gpgSign = true;
        gpg = {
          format = "ssh";
          "ssh".program = getExe' openssh "ssh-keygen";
        };
      };
  };
}
