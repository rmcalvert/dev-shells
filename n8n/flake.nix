{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        unstable_pkgs = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true; # Required for claude-code
        };
      in
      {
        devShell =
          with pkgs;

          mkShell {
            buildInputs = [
              unstable_pkgs.n8n
              unstable_pkgs.claude-code
            ];
            shellHook = '''';
          };
      }
    );
}
