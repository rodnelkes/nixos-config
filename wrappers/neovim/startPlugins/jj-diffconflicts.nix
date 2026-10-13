{ inputs, vimUtils }:

vimUtils.buildVimPlugin {
  name = "jj-diffconflicts";
  src = inputs.sources.jj-diffconflicts.outPath;
}
