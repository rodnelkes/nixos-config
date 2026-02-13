{ types, ... }:

{
  name = "bupkes";

  options = {
    host.type = types.attrs;
    lib.type = types.attrs;
    user.type = types.attrs;
  };
}
