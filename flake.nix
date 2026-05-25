{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    esp-idf.url = "github:mirrexagon/nixpkgs-esp-dev";
  };

  outputs = { self, nixpkgs, flake-utils, esp-idf, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            esp-idf.overlays.default
          ];
        };

        # Determine architecture-specific properties
        platformSrc = if system == "x86_64-linux" then
          {
            url = "https://github.com/kassane/zig-espressif-bootstrap/releases/download/0.16.0-xtensa/zig-relsafe-x86_64-linux-musl-baseline.tar.xz";
            sha256 = "sha256-nj3O+db21VLfZBoSrdyeRDppt8va2FSS7Gd6zVW33ps=";
          }
        else if system == "aarch64-linux" then
          {
            url = "https://github.com/kassane/zig-espressif-bootstrap/releases/download/0.16.0-xtensa/zig-relsafe-aarch64-linux-musl-baseline.tar.xz";
            sha256 = "sha256-UwT0PNMN/L3FVf3j4rZQG0g4Miukfdcdo0ER4IsC7vQ=";
          }
        else
          throw "Unsupported platform: ${system}";

      in
      with pkgs;
      {
        formatter = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
        devShells.default = mkShell {
          buildInputs = [
            bashInteractive

            (pkgs.stdenv.mkDerivation {
              pname = "zig-espressif-bootstrap";
              version = "0.16.0-xtensa-dev";
              src = pkgs.fetchurl platformSrc;
              dontConfigure = true;
              dontBuild = true;
              dontFixup = true;
              installPhase = ''
                mkdir -p $out/{doc,bin,lib}
                cp -r doc/* $out/doc
                cp -r lib/* $out/lib
                cp zig $out/bin/zig
              '';
            })

            pkgs.zls

            esp-idf-full
          ];
        };
      }
    );
}
