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
        # # unstable_pkgs = nixpkgs-unstable.legacyPackages.${system};
        unstable_pkgs = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true; # Required for claude-code
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
        # environment.systemPackages = with pkgs; [
        # ];
        devShell =
          with pkgs;

          mkShell {
            # BUNDLE_PATH = ".bundle/gems";
            # GEM_HOME = ".gems";
            # GEM_PATH = ".gems";
            buildInputs = [
              # (python312.withPackages (
              #   ps: with ps; [
              #     pipx
              #     chromadb
              #     sentence-transformers
              #   ]
              # ))
              # my_ruby
              unstable_pkgs.mise
              # gems # defined above
              ### # bundix
              openssl_3
              gmp
              libyaml
              libz
              # rust # for mise
              watchman # watch for file changes. Used by sorbet lsp server
              postgresql
              redis

              # # unstable_pkgs.vectorcode
              unstable_pkgs.claude-code
            ];
            # Find a better way. VectorCode from nixpkgs-unstable is generating "google.rpc"
            # ModuleNotFound error when chroma starts. Not currently available in nixpkgs stable

            # On a new project:
            #   1. start chroma (chroma run --path ./chromadb)
            #   2. vectorcode init
            #   3. vectorcode vectorize app/**/*.rb
            shellHook = ''
              ## export PATH=".gems/bin:$HOME/.local/bin:$PATH"
              eval "$(mise activate)"
              # export PATH=".gems/bin:$PATH"
              # pipx install chromadb
              # pipx upgrade vectorcode
              # pipx install sentence-transformers
            '';
          };
      }
    );
}
