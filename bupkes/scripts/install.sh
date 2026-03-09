#!/run/current-system/sw/bin/bash

username="${1}"
hostname="${2}"
ip="${3}"
temp="$(mktemp -d)"

function cleanup() {
    rm -rf "${temp}"
}
trap cleanup EXIT

function create_ssh_key() {
    local user="${1}"
    local key_path="${2}"
    local dir_mode="${3}"

    install -d -m"${dir_mode}" "$(dirname "${key_path}")"

    ssh-keygen -t ed25519 -a 100 -N "" -C "${user}@${hostname}" -f "${key_path}"

    chmod 600 "${key_path}"
    chmod 644 "${key_path}.pub"
}

function update_keys_repository() {
    local ssh_host_key_path="${temp}"/persistent/etc/ssh/ssh_host_ed25519_key

    create_ssh_key "root" "${ssh_host_key_path}" "755"

    sed -i \
        "s|${hostname} = \".*\";|${hostname} = \"$(cat "${ssh_host_key_path}.pub")\";|" \
        ~/nixos-config/bupkes/secrets/secrets.nix

    cd ~/nixos-config/bupkes/secrets/ || exit
    agenix --rekey
    cd ~/nixos-config/ || exit
}

function build_host() {
    nom-build \
        -A "${hostname}".config.system.build.diskoScript \
        -A "${hostname}".config.system.build.toplevel \
        --no-out-link
}

function nixos_anywhere() {
    # shellcheck disable=SC2086
    nix run github:nix-community/nixos-anywhere -- \
        --extra-files "${temp}" \
        --store-paths $1 \
        root@"${ip}"
}

function create_host() {
    update_keys_repository
    nixos_anywhere "$(build_host)"
}

create_host
