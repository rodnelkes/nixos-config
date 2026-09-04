_:

{
  options = {
    config.mutators = [ "/gh" ];
    hosts.mutators = [ "/gh" ];
  };

  mutations."/gh" = {
    config =
      _:
      # yaml
      {
        version = 1;
        git_protocol = "https";
        editor = null;
        prompt = "enabled";
        prefer_editor_prompt = "disabled";
        pager = null;
        aliases.co = "pr checkout";
        http_unix_socket = null;
        browser = null;
        color_labels = "disabled";
        accessible_colors = "disabled";
        accessible_prompter = "disabled";
        spinner = "enabled";
      };

    hosts =
      _:
      # yaml
      {
        "github.com".git_protocol = "ssh";
      };
  };
}
