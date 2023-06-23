{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
  };

  outputs = { self, nixpkgs, flake-utils, naersk, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          naersk' = pkgs.callPackage naersk { };
        in
        with pkgs;
        {
          devShells = {
            default = mkShell
              {
                buildInputs = [
                  cargo
                  openssl
                  pkg-config
                ];

                LD_LIBRARY_PATH = lib.makeLibraryPath [ openssl ];
              };
          };

          defaultPackage = naersk'.buildPackage ({
            name = "demo";
            src = ./demo;
            buildInputs = [
              openssl
              pkg-config
            ];
          });
        }
      );
}
