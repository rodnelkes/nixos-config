#!/run/current-system/sw/bin/bash

hostname=$1
ip=$2
temp=$(mktemp -d)

function cleanup() {
    rm -rf "${temp}"
}
trap cleanup EXIT

function copy_installation_keys() {
    cd ~/nixos-config/bupkes/secrets/ || exit

    install -d -m755 "${temp}/persistent/etc/ssh"
    output_path=${temp}/persistent/etc/ssh/ssh_host_ed25519_key

    agenix -d installation_key.age >"${output_path}"
    chmod 600 "${output_path}"

    cd ../../
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
    copy_installation_keys
    nixos_anywhere "$(build_host)"
}

create_host
