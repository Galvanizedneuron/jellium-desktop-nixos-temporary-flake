{
  stdenv,
  jellium-desktop_nixpkgs,
  metaSkeleton,
}:
stdenv.mkDerivation (finalAttrs: {
  src = ../../../../resources;
  pname = "${jellium-desktop_nixpkgs.pname}-resources";
  inherit (jellium-desktop_nixpkgs) version;
  dontUnpack = true;
  installPhase = ''
    cp -r $src $out
  '';
  meta = metaSkeleton;
})
