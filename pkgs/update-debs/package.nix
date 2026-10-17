{
  writeShellApplication,
  coreutils,
  curl,
  gawk,
  gnupg,
  jq,
}:

writeShellApplication {
  name = "update-debs";
  runtimeInputs = [
    coreutils
    curl
    gawk
    gnupg
    jq
  ];
  text = builtins.readFile ./update-debs.sh;
}
