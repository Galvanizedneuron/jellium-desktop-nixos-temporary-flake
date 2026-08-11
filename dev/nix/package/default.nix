{ inputs, self, ... }: {
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];
  perSystem =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      overlayAttrs = {
        inherit (config.packages) jellium-desktop;
      };
      packages =
        let
          craneLib = inputs.crane.mkLib pkgs;
        in
        (lib.fix (
          p:
          let
            metaSkeleton = {
              inherit (p.jellium-desktop_nixpkgs.meta)
                homepage
                license
                maintainers
                description
                ;
            };
            craneCommonArgs = {
              src = ../../../src;
              strictDeps = true;

              inherit (p.jellium-desktop_nixpkgs)
                version
                pname
                passthru
                buildInputs
                ;

              nativeBuildInputs = with pkgs; [ 
                pkg-config 
                rustPlatform.bindgenHook
              ];

              CEF_PATH = p.cef-lib;
              EXTERNAL_MPV_DIR = p.mpv-external-prefix;

              cargoExtraArgs = "--bin jellium-desktop";

              meta = metaSkeleton;
            };

          in
          (lib.mapAttrs (n: pkgs.callPackage ./_packages/${n}.nix) {
            cef-binary = { };
            cef-lib = { inherit (p) cef-binary; };
            jellium-desktop_resources = {
              inherit (p) jellium-desktop_nixpkgs;
              inherit metaSkeleton;
            };
            jellium-desktop_nixpkgs = {
              inherit (p) cef-lib mpv-external-prefix;
              inherit (self) lastModifiedDate;
            };
            jellium-desktop_crane-deps = {
              inherit craneLib craneCommonArgs metaSkeleton;
            };
            jellium-desktop_crane = {
              inherit craneLib craneCommonArgs;
              inherit (p) jellium-desktop_crane-deps jellium-desktop_resources jellium-desktop_nixpkgs;
            };
            mpv-external-prefix = { };
          })
          // {
            jellium-desktop = p.jellium-desktop_crane;
            default = p.jellium-desktop;
          }
        ));
    };
}
