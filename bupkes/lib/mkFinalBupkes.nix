{
  sources,
  pkgs,
  bupkes,
}:

hostVars:
let
  # First applies hostVars to bupkes
  bupkesHostVars = bupkes // {
    host = bupkes.host // hostVars;
  };

  # Then applies wrappers to bupkesHostVars...
  finalBupkes = bupkesHostVars // {
    wrappers = import ../../wrappers {
      inherit sources pkgs;

      # ...while also passing bupkesHostVars to wrappers as an arg
      bupkes = bupkesHostVars;
    };
  };
in
finalBupkes
