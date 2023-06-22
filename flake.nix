{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        with pkgs;
        {
          devShells = {
            default = mkShell
              {
                buildInputs = [
                  openssl
                  pkg-config
                  cargo
                ];
                LD_LIBRARY_PATH = lib.makeLibraryPath [ openssl ];
              };
          };

          packages = { };
        }
      );
}
