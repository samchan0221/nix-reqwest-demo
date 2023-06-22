{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    rust-overlay.url = "github:oxalica/rust-overlay/stable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, naersk, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [ (import rust-overlay) ];
          pkgs = import nixpkgs {
            inherit system overlays;
          };
          rust-toolchain = pkgs.rust-bin.stable."1.70.0".default;
          nixos-lib = import (nixpkgs + "/nixos/lib") { };
        in
        with pkgs;
        {
          devShells = {
            default = mkShell
              {
                buildInputs = [
                  # musl
                  openssl
                  pkg-config
                  # glibc
                  (rust-toolchain.override {
                    extensions = [
                      "rust-src"
                      "rust-analyzer"
                    ];
                  })
                  cargo-watch
                  cargo-audit
                  cargo-expand
                  cargo-machete
                  sqlx-cli
                ];
                LD_LIBRARY_PATH = lib.makeLibraryPath [ openssl ];
              };
          };

          packages = { };
        }
      );
}



