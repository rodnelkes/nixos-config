{
  nix = {
    optimise = {
      automatic = true;
      dates = [ "daily" ];
    };

    gc = {
      automatic = true;
      dates = [ "daily" ];
    };
  };
}
