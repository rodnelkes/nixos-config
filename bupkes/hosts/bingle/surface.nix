{ sources, ... }:

{
  imports = [ (import "${sources.nixos-hardware}/microsoft/surface/surface-pro-intel") ];

  hardware.microsoft-surface.kernelVersion = "stable";
}
