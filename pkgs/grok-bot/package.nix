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
  dbus,
  expat,
  glib,
  gtk3,
  libGL,
  libgbm,
  libnotify,
  libpulseaudio,
  libsecret,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  nspr,
  nss,
  pango,
  pciutils,
  pipewire,
  systemd,
  vulkan-loader,
  xdg-utils,
}:

let
  source = lib.importJSON ./source.json;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "grok-bot";
  inherit (source) version;

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
    dbus
    expat
    glib
    gtk3
    libgbm
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    nspr
    nss
    pango
    (lib.getLib stdenv.cc.cc)
    (lib.getLib systemd)
  ];

  appendRunpaths = map (pkg: "${lib.getLib pkg}/lib") [
    libGL
    pciutils
    vulkan-loader
  ];

  runtimeDependencies = [
    gtk3
    libGL
    libnotify
    libpulseaudio
    libsecret
    pciutils
    pipewire
    vulkan-loader
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
    cp -r "opt/Grok Bot" $out/lib/grok-bot
    cp -r usr/share/applications usr/share/icons $out/share
    ln -sf ${lib.getLib vulkan-loader}/lib/libvulkan.so.1 $out/lib/grok-bot/libvulkan.so.1

    runHook postInstall
  '';

  preFixup = ''
    makeBinaryWrapper $out/lib/grok-bot/grok-bot $out/bin/${finalAttrs.meta.mainProgram} \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  meta = {
    description = "Grok Bot desktop agent";
    homepage = "https://x.ai/bot";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "grok-bot";
  };
})
