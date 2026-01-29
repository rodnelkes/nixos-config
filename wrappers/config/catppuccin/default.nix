_:

{
  name = "catppuccin";

  inputs = {
    nixpkgs.path = "/nixpkgs";
  };

  mutations = {
    "/nushell".configPaths =
      { inputs }:
      let
        inherit (inputs.nixpkgs.pkgs) fetchFromGitHub writeText;

        catppuccinNushell = fetchFromGitHub {
          owner = "catppuccin";
          repo = "nushell";
          rev = "815dfc6ea61f2746ff27b54ef425cfeb7b51dda8";
          hash = "sha256-124T2pCmwirl8eLAy3h1fDOQZJf//3KJ7GwIP+u6YQ4=";
        };

        config =
          writeText "nushell-catppuccin-mocha"
            # nu
            ''
              source ${catppuccinNushell}/themes/catppuccin_mocha.nu
            '';
      in
      [ config ];
  };
}
