{ cef-binary }:
let
  version = "149.0.6";
in
(
  if (cef-binary.version == version) then
    cef-binary
  else
    (cef-binary.override {
      inherit version;
      gitRevision = "0d0eeb6";
      chromiumVersion = "149.0.7827.201";
      srcHashes = {
        aarch64-linux = "sha256-iqh8Dw6Ei3R5A/+9XldRF5wb3t8yr7Mq+q1R3Xd8lg0=";
        x86_64-linux = "sha256-+Q3sTFxCp7vU8r2Ap6d+Csaqz8Zie7Q1ctgD538m37w=";
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
