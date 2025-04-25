{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-ruby = {
      url = "github:bobvanderlinden/nixpkgs-ruby";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-ruby,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        unstable_pkgs = nixpkgs-unstable.legacyPackages.${system};
        ruby = nixpkgs-ruby.lib.packageFromRubyVersionFile {
          file = ./.ruby-version;
          inherit system;
        };
      in
      # gems = pkgs.bundlerEnv {
      #   name = "gemset";
      #   inherit ruby;
      #   gemfile = ./Gemfile;
      #   lockfile = ./Gemfile.lock;
      #   gemset = ./gemset.nix;
      #   groups = [
      #     "default"
      #     "production"
      #     "development"
      #     "test"
      #   ];
      # };
      {
        devShell =
          with pkgs;
          mkShell {
            BUNDLE_PATH = ".bundle/gems";
            GEM_HOME = ".gems";
            GEM_PATH = ".gems";
            buildInputs = [
              ruby
              # gems
              libyaml
              # bundix
              openssl_3
              gmp
              watchman # watch for file changes. Used by sorbet lsp server
              postgresql
              redis

              unstable_pkgs.vectorcode
            ];
            shellHook = ''
              export PATH=".gems/bin:$PATH"
            '';
          };
      }
    );
}
