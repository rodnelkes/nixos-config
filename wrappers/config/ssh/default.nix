_:

{
  name = "ssh";

  mutations = {
    "/nushell".configPaths = _: [ ./eval_ssh-agent.nu ];
  };
}
