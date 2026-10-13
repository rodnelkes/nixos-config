{
  pkgs,
  bupkes,
  ...
}:

{
  environment = {
    systemPackages = [
      pkgs.wl-clipboard-rs
      bupkes.wrappers.neovim.result
    ];

    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
