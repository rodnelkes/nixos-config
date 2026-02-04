# https://github.com/nushell/nushell.github.io/blob/c50965b75f2903f4e27fe1cc6e0efe050a163e85/cookbook/ssh_agent.md?plain=1#L28
do --env {
    let ssh_agent_file = (
        $nu.temp-dir | path join $"ssh-agent-(whoami).nuon"
    )

    if ($ssh_agent_file | path exists) {
        let ssh_agent_env = open ($ssh_agent_file)
        if ($"/proc/($ssh_agent_env.SSH_AGENT_PID)" | path exists) {
            load-env $ssh_agent_env
            return
        } else {
            rm $ssh_agent_file
        }
    }

    let ssh_agent_env = ^ssh-agent -c
        | lines
        | first 2
        | parse "setenv {name} {value};"
        | transpose --header-row
        | into record
    load-env $ssh_agent_env
    $ssh_agent_env | save --force $ssh_agent_file
}
