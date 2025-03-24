{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {

        # used by nix shell and nix develop
        devShell = with pkgs;
          mkShell {
            nativeBuildInputs = [ ruby bundler libyaml openssl_3 gmp postgresql redis ];
          };
      });
}
