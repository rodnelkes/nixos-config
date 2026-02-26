_:

{
  name = "direnv";

  mutations = {
    "/nushell".configPaths = _: [ ./direnv.nu ];
  };
}
