# Run with: nix develop
{
  description = "Development environment for Ruby and Rails";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  allSystems = [
    "x86_64-linux" # 64-bit Intel/AMD Linux
    "aarch64-linux" # 64-bit ARM Linux
    "x86_64-darwin" # 64-bit Intel macOS
    "aarch64-darwin" # 64-bit ARM macOS
  ];

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.lib.mkEnv {
        system = "aarch64-darwin"; # aarch64-darwin, x86_64-linux
        packages = pkgs: [
          pkgs.ruby_3_4
          # pkgs.rails
          pkgs.redis
          pkgs.postgresql
        ];
      };
    in { devShell = pkgs; };
}
