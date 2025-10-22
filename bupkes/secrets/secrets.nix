let
  inherit (builtins) attrValues;

  users = {
    "rodnelkes@boobookeys" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHpTlwHpvrCyOBYGWYKpFM7Q0OYC8bP39gKU4jpK8AWp rodnelkes@boobookeys";
    # "rodnelkes@bingle" = "";
  };
  systems = {
    boobookeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtDEDKhmXloobbC2FRZgfbfVREU94CJn75JFv8eJlMG root@boobookeys";
    # bingle = "";
  };

  userKeys = attrValues users;
  systemKeys = attrValues systems;
in
{
  "user_password.age".publicKeys = userKeys ++ systemKeys;
  "github.age".publicKeys = userKeys ++ systemKeys;
}
