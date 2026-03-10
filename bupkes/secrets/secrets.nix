let
  inherit (builtins) attrValues;

  users = {
    "rodnelkes@amende" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDaLWsbY4PoUI6xKJlmuzFCCC2hpj6eIPAMiFeaH1bsa rodnelkes@amende";
    "rodnelkes@boobookeys" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHpTlwHpvrCyOBYGWYKpFM7Q0OYC8bP39gKU4jpK8AWp rodnelkes@boobookeys";
    "rodnelkes@bingle" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMOnFR3Mogjp+bnWYmCD/KujxtqghlXiKBXI1qsLx+Q8 rodnelkes@bingle";
  };
  systems = {
    amende = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILE+GmyhjSsejky9iuZ3UFXIhHgplzvYH7XRDC6bJmao root@amende";
    boobookeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtDEDKhmXloobbC2FRZgfbfVREU94CJn75JFv8eJlMG root@boobookeys";
    bingle = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINWDQ+59qh8Y8imkqj3pWdel5miFlVJUhrnccnl9tj70 root@bingle";
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
