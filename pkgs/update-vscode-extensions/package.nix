{
  writeShellApplication,
  coreutils,
  curl,
  jq,
  vscode,
}:

writeShellApplication {
  name = "update-vscode-extensions";
  runtimeInputs = [
    coreutils
    curl
    jq
  ];
  runtimeEnv.VSCE_SIGN = "${vscode}/lib/vscode/resources/app/node_modules.asar.unpacked/@vscode/vsce-sign/bin/vsce-sign";
  text = builtins.readFile ./update-vscode-extensions.sh;
}
