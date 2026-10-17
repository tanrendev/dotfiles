{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  makeBinaryWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-core,
  cairo,
  cups,
  curl,
  dbus,
  expat,
  fontconfig,
  getconf,
  glib,
  gtk3,
  libGL,
  libgbm,
  libnotify,
  libpulseaudio,
  libsecret,
  libsoup_3,
  libuuid,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxkbfile,
  libxrandr,
  nspr,
  nss,
  openssl,
  pango,
  pciutils,
  pipewire,
  systemd,
  vulkan-loader,
  wayland,
  webkitgtk_4_1,
  xdg-utils,
}:

let
  source = lib.importJSON ./source.json;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vscode";
  version = lib.head (lib.splitString "-" source.version);

  src = fetchurl { inherit (source) url hash; };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeBinaryWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    at-spi2-core
    cairo
    cups
    curl
    dbus
    expat
    glib
    gtk3
    libgbm
    libsecret
    libsoup_3
    libuuid
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxkbfile
    libxrandr
    nspr
    nss
    openssl
    pango
    (lib.getLib stdenv.cc.cc)
    (lib.getLib systemd)
  ];

  autoPatchelfIgnoreMissingDeps = [ "libwebkit2gtk-4.1.so.0" ];
  appendRunpaths = map (pkg: "${lib.getLib pkg}/lib") [
    libGL
    pciutils
    vulkan-loader
    webkitgtk_4_1
  ];

  runtimeDependencies = [
    gtk3
    libGL
    libnotify
    libpulseaudio
    libsecret
    openssl
    pciutils
    pipewire
    vulkan-loader
    wayland
    (lib.getLib fontconfig)
    (lib.getLib systemd)
  ];

  dontConfigure = true;
  dontBuild = true;
  dontWrapGApps = true;
  dontStrip = true;
  dontPatchShebangs = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/share
    cp -r usr/share/code $out/lib/vscode
    cp -r usr/share/applications usr/share/pixmaps usr/share/mime usr/share/bash-completion usr/share/zsh $out/share
    ln -sf ${lib.getLib vulkan-loader}/lib/libvulkan.so.1 $out/lib/vscode/libvulkan.so.1

    substituteInPlace $out/share/applications/com.microsoft.VSCode.desktop $out/share/applications/com.microsoft.VSCode.UrlHandler.desktop \
      --replace-fail "Exec=/usr/share/code/code" "Exec=${finalAttrs.meta.mainProgram}"

    runHook postInstall
  '';

  preFixup = ''
    makeBinaryWrapper $out/lib/vscode/bin/code $out/bin/${finalAttrs.meta.mainProgram} \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : ${
        lib.makeBinPath [
          getconf
          glib
          xdg-utils
        ]
      }
  '';

  postFixup = ''
    patchelf --add-needed ${lib.getLib openssl}/lib/libssl.so \
      $out/lib/vscode/resources/app/node_modules.asar.unpacked/@vscode/vsce-sign/bin/vsce-sign
  '';

  meta = {
    description = "Code editor by Microsoft";
    homepage = "https://code.visualstudio.com/";
    changelog = "https://code.visualstudio.com/updates";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "code";
  };
})
