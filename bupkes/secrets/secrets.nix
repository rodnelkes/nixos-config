let
  inherit (builtins) attrValues;

  users = {
    "rodnelkes@amende" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDaLWsbY4PoUI6xKJlmuzFCCC2hpj6eIPAMiFeaH1bsa rodnelkes@amende";
    "rodnelkes@boobookeys" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHpTlwHpvrCyOBYGWYKpFM7Q0OYC8bP39gKU4jpK8AWp rodnelkes@boobookeys";
    "rodnelkes@bingle" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEF4PuFasEcnH3TePlMPl0k9dkaRWiPh/9BgzC7BLlES rodnelkes@bingle";
  };
  hosts = {
    amende = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILE+GmyhjSsejky9iuZ3UFXIhHgplzvYH7XRDC6bJmao root@amende";
    boobookeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtDEDKhmXloobbC2FRZgfbfVREU94CJn75JFv8eJlMG root@boobookeys";
    bingle = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFqPanrn4FUbQloNzGd2UMvEs3Yzvy1UHT+yLr5+AMtz root@bingle";
  };
  installationKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqDOSRs002nj3Bhe5vWdi//sEBUyF6J4XiQB2Hk5K2u installation";

  userKeys = attrValues users;
  hostKeys = attrValues hosts;
  allKeys = userKeys ++ hostKeys ++ [ installationKey ];

  getSystemKeys = system: [
    users."rodnelkes@${system}"
    hosts.${system}
  ];
in
{
  "installation_key.age".publicKeys = allKeys;

  "user_password.age".publicKeys = allKeys;

  "github.age".publicKeys = allKeys;
  "allowed-signers.age".publicKeys = allKeys;

  "wg-amende-private.age".publicKeys = getSystemKeys "amende";
  "wg-amende-preshared.age".publicKeys = getSystemKeys "amende";
  "wg-bingle-private.age".publicKeys = getSystemKeys "bingle";
  "wg-bingle-preshared.age".publicKeys = getSystemKeys "bingle";
}
