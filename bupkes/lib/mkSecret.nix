{ bupkes, ... }:

name: mode: owner: {
  ${name} = {
    inherit mode owner;
    file = /. + "${bupkes.host.configDirectory}/bupkes/secrets/${name}.age";
  };
}
