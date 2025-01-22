{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zls-overlay.url = "github:zigtools/zls/edd8f2264ea45f7370bac4aba809bc179d96627e";
    esp-idf.url = "github:mirrexagon/nixpkgs-esp-dev";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , zls-overlay
    , esp-idf
    ,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            esp-idf.overlays.default
            (final: prev: {
              zls = zls-overlay.packages.${system}.default;
              zig = pkgs.stdenv.mkDerivation {
                pname = "zig-espressif-bootstrap";
                version = "0.14.0-xtensa-dev";

                src = pkgs.fetchurl {
                  url = "https://github.com/kassane/zig-espressif-bootstrap/releases/download/0.14.0-xtensa-dev/zig-relsafe-espressif-x86_64-linux-musl-baseline.tar.xz";
                  sha256 = "sha256-KAFGYgUP1poWbUJCsvqrJIs7VyZayWbGDqeD+jUG7og=";
                };
                dontConfigure = true;
                dontBuild = true;
                dontFixup = true;
                installPhase = ''
                  mkdir -p $out/{doc,bin,lib}
                  cp -r doc/* $out/doc
                  cp -r lib/* $out/lib
                  cp zig $out/bin/zig
                '';
              };
            })
          ];
        };
      in
      with pkgs;
      {
        formatter = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
        devShells.default = mkShell {
          buildInputs = [
            bashInteractive

            zig
            zls

            esp-idf-full
          ];
        };
      }
    );
}
