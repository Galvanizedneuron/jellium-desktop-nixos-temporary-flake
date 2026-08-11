{
  craneLib,
  craneCommonArgs,
  rustPlatform,
  pkg-config,
  wrapGAppsHook4,

  # Dependencies
  jellyfin-desktop_crane-deps,
  jellyfin-desktop_resources,

  jellyfin-desktop_nixpkgs,
}:
craneLib.buildPackage (
  craneCommonArgs
  // {

    nativeBuildInputs = [
      wrapGAppsHook4
      pkg-config
      rustPlatform.bindgenHook
    ];

    cargoArtifacts = jellyfin-desktop_crane-deps;

    installPhase = ''
      runHook preInstall

      install -Dm755 \
        target/release/jellium-desktop \
        $out/bin/jellium-desktop

      install -Dm644 \
        ${jellyfin-desktop_resources}/linux/net.nullsum.JelliumDesktop.desktop \
        $out/share/applications/net.nullsum.JelliumDesktop.desktop
      install -Dm644 \
        ${jellyfin-desktop_resources}/linux/net.nullsum.JelliumDesktop.metainfo.xml \
        $out/share/metainfo/net.nullsum.JelliumDesktop.metainfo.xml
      install -Dm644 \
        ${jellyfin-desktop_resources}/linux/net.nullsum.JelliumDesktop.svg \
        $out/share/icons/hicolor/scalable/apps/net.nullsum.JelliumDesktop.svg

      runHook postInstall
    '';

    inherit (jellyfin-desktop_nixpkgs) preFixup;
  }
)
