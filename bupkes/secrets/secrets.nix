let
  inherit (builtins) attrValues;

  users = {
    "rodnelkes@boobookeys" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHpTlwHpvrCyOBYGWYKpFM7Q0OYC8bP39gKU4jpK8AWp rodnelkes@boobookeys";
    "rodnelkes@bingle" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC4ohdI7U/iUXzgbvUOHF79x8wld8/Vj2BY9a6bBl/5k rodnelkes@bingle";
  };
  systems = {
    boobookeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtDEDKhmXloobbC2FRZgfbfVREU94CJn75JFv8eJlMG root@boobookeys";
    bingle = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICLBDTQt5H8xj8ReSk/pwWmBQrYLIpRxjQszQcQLN1hC root@bingle";
  };
  installationKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqDOSRs002nj3Bhe5vWdi//sEBUyF6J4XiQB2Hk5K2u installation";

  userKeys = attrValues users;
  systemKeys = attrValues systems;
  allKeys = userKeys ++ systemKeys ++ [ installationKey ];
in
{
  "user_password.age".publicKeys = allKeys;
  "github.age".publicKeys = allKeys;
  "installation_key.age".publicKeys = allKeys;
  "allowed-signers.age".publicKeys = allKeys;
}
