{
  craneLib,
  craneCommonArgs,
  rustPlatform,
  pkg-config,
  wrapGAppsHook4,

  # Dependencies
  jellium-desktop_crane-deps,
  jellium-desktop_resources,

  jellium-desktop_nixpkgs,
}:
craneLib.buildPackage (
  craneCommonArgs
  // {

    nativeBuildInputs = [
      wrapGAppsHook4
      pkg-config
      rustPlatform.bindgenHook
    ];

    cargoArtifacts = jellium-desktop_crane-deps;

    installPhase = ''
      runHook preInstall

      install -Dm755 \
        target/release/jellium-desktop \
        $out/bin/jellium-desktop

      install -Dm644 \
        ${jellium-desktop_resources}/linux/net.nullsum.JelliumDesktop.desktop \
        $out/share/applications/net.nullsum.JelliumDesktop.desktop
      install -Dm644 \
        ${jellium-desktop_resources}/linux/net.nullsum.JelliumDesktop.metainfo.xml \
        $out/share/metainfo/net.nullsum.JelliumDesktop.metainfo.xml
      install -Dm644 \
        ${jellium-desktop_resources}/linux/net.nullsum.JelliumDesktop.svg \
        $out/share/icons/hicolor/scalable/apps/net.nullsum.JelliumDesktop.svg

      runHook postInstall
    '';

    inherit (jellium-desktop_nixpkgs) preFixup;
  }
)
