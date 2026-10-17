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
  pname = "signal-desktop";
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
    libpulseaudio
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

    mkdir -p $out/lib $out/share/polkit-1/actions
    cp -r opt/Signal $out/lib/signal-desktop
    cp -r usr/share/applications usr/share/icons $out/share
    mv $out/lib/signal-desktop/resources/*.policy $out/share/polkit-1/actions
    ln -sf ${lib.getLib vulkan-loader}/lib/libvulkan.so.1 $out/lib/signal-desktop/libvulkan.so.1

    mv $out/share/applications/signal-desktop.desktop $out/share/applications/signal.desktop
    substituteInPlace $out/share/applications/signal.desktop \
      --replace-fail "Exec=/opt/Signal/signal-desktop" "Exec=${finalAttrs.meta.mainProgram}"

    runHook postInstall
  '';

  preFixup = ''
    makeBinaryWrapper $out/lib/signal-desktop/signal-desktop $out/bin/${finalAttrs.meta.mainProgram} \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  meta = {
    description = "Private messaging from your desktop";
    homepage = "https://signal.org/";
    changelog = "https://github.com/signalapp/Signal-Desktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "signal-desktop";
  };
})
