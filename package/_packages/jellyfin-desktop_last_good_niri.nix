{
  fetchFromGitHub,
  jellyfin-desktop,
  cef-binary,
  cef-lib,
}:
let
  cef-bin = cef-binary.override {
    version = "148.0.10";
    gitRevision = "7ee53f5";
    chromiumVersion = "148.0.7778.218";
    srcHashes = {
      aarch64-linux = "sha256-cBAvcvs1rAg5EKJkCt81RZYupCWpUNIC/nLt3PJow7Q="; # wrong hash btw
      x86_64-linux = "sha256-tKcIC8OtMgjppwBQJsXwaXaN7lEr8ivJKRt7Nm6j+Mw=";
    };
  };
in
(jellyfin-desktop.override {
  cef-lib = cef-lib.override { cef-binary = cef-bin; };
  wl-proxy-hash = "sha256-zssZ6kJTw7GrwXJBdvxc+HWdIKaqb/SfUqT/VTaI4pI=";
}).overrideAttrs
  (old: {
    src = fetchFromGitHub {
      owner = "jellyfin";
      repo = "jellyfin-desktop";
      rev = "81afa6d0be5e9eb1e6ea2c1c5e25ab68a7b532c8";
      hash = "sha256-f42jTE92an3S7XShUyosvlj9It+H8IiHRJtFfiV2uM0=";
      meta = old.meta // {
        broken = true;
      };
    };
  })
