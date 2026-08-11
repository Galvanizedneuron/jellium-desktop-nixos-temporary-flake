{ cef-binary }:
let
  version = "151.3.16";
in
(
  if (cef-binary.version == version) then
    cef-binary
  else
    (cef-binary.override {
      inherit version;
      gitRevision = "be1e15d";
      chromiumVersion = "151.0.7922.109";
      srcHashes = {
        aarch64-linux = "sha256-gRYcEylZAUvKTOmV1zw9TyiEkv6FZ0vhVT1mLwne57k=";
        x86_64-linux = "sha256-6usxPmA53kZIVYk9KHxNXrTscSaXjqg8YWS/SiPcAXo=";
      };
    })
).overrideAttrs
  (old: {
    # make nix understand that src and version are defined in this file
    inherit (old) src version;

    passthru = old.passthru // {
      updateScript = ./update-cef.sh;
    };
  })
