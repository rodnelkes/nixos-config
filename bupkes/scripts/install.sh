#!/run/current-system/sw/bin/bash

cd ~/nixos-config/ || exit

ip=$2
hostname=$1

temp=$(mktemp -d)

cleanup() {
    rm -rf "${temp}"
}
trap cleanup EXIT

install -d -m755 "${temp}/etc/ssh"
cd ./bupkes/secrets/ || exit

for type in ed25519 rsa; do
    output_path=${temp}/etc/ssh/ssh_host_${type}_key

    agenix -d installation_key.age >"${output_path}"
    chmod 600 "${output_path}"
done

cd ../../

build_host=$(nom-build -A "${hostname}".config.system.build.diskoScript -A "${hostname}".config.system.build.toplevel --no-out-link)
# shellcheck disable=SC2086
nix run github:nix-community/nixos-anywhere -- --extra-files "${temp}" --store-paths ${build_host} root@"${ip}"
