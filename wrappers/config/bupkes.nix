{ types, ... }:

{
  name = "bupkes";

  options = {
    lib.type = types.attrs;
    user.type = types.attrs;
  };
}
