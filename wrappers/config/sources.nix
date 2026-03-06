{ types, ... }:

{
  name = "sources";

  options = {
    catppuccin-nushell.type = types.attrs;
    catppuccin-fzf.type = types.attrs;
  };
}
