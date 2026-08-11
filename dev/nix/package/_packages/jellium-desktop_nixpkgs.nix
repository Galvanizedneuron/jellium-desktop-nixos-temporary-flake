{
  lib,
  rustPlatform,
  pkg-config,
  wrapGAppsHook4,

  # Needed at runtime by CEF
  libGL,

  # Dependencies
  ffmpeg,
  libxkbcommon,
  libxcb,
  cef-lib,
  mpv-external-prefix,

  lastModifiedDate,

  cargoHash ? "sha256-GqSk6ZjY34esHGBmaY7sbFjQI6q9e4J3Qu87tFEW6O0=",
  wl-proxy-hash ? "sha256-8NMNPhBSW2gLXc9bwyg2kmHb12XIaV6b4PjM62xLldQ=",
}:
rustPlatform.buildRustPackage (finalAttrs: {
  src = ../../../..;
  pname = "jellium-desktop";
  version =
    let
      majorVersion =
        (lib.importTOML "${finalAttrs.src}/${finalAttrs.cargoRoot}/Cargo.toml").workspace.package.version;

      s = b: l: builtins.substring b l lastModifiedDate;
      date = "${s 0 4}-${s 4 2}-${s 6 2}";
    in
    "${majorVersion}-${date}";

  # Fixes some Cargo.lock issues
  cargoRoot = "src";
  inherit cargoHash;
  cargoLock = {
    # Fixes some other Cargo.lock issues
    lockFile = "${finalAttrs.src}/${finalAttrs.cargoRoot}/Cargo.lock";
    outputHashes = {
      "wl-proxy-0.1.2" = wl-proxy-hash;
    };
  };

  strictDeps = true;

  nativeBuildInputs = [
    wrapGAppsHook4
    rustPlatform.bindgenHook # fixes clang issues
    pkg-config
  ];

  buildInputs = [
    libxcb
    libxkbcommon
    ffmpeg
  ];

  buildPhase = ''
    runHook preBuild
    cargo xtask build \
      --cef-path ${cef-lib} \
      --external-mpv ${mpv-external-prefix} \
      --out build/
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 \
      build/jellium-desktop \
      $out/bin/jellium-desktop

    install -Dm644 \
      resources/linux/net.nullsum.JelliumDesktop.desktop \
      $out/share/applications/net.nullsum.JelliumDesktop.desktop
    install -Dm644 \
      resources/linux/net.nullsum.JelliumDesktop.metainfo.xml \
      $out/share/metainfo/net.nullsum.JelliumDesktop.metainfo.xml
    install -Dm644 \
      resources/linux/net.nullsum.JelliumDesktop.svg \
      $out/share/icons/hicolor/scalable/apps/net.nullsum.JelliumDesktop.svg

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}" \
    )
  '';

  doCheck = false;

  meta = {
    description = "jellium desktop client";
    homepage = "https://github.com/andrewrabert/jellium-desktop";
    license = lib.licenses.gpl2Only;
    mainProgram = "jellium-desktop";
    # TODO: add myself once this goes on nixpkgs.
    maintainers = with lib.maintainers; [
      {
        email = "hey+dev@xaltsc.dev";
        name = "xaltsc";
        github = "xaltsc";
        githubId = 41400742;
      }
    ];
  };
})
