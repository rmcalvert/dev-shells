{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true; # Required for claude-code, intellij
        };
        java = pkgs.zulu23;
        gradle = pkgs.gradle.override { inherit java; };
        kotlin = pkgs.kotlin.override { jre = java; };
        intellij = unstable.jetbrains.idea-ultimate;
        claude-code = unstable.claude-code;
      in
      {
        devShell =
          with pkgs;
          mkShell {
            buildInputs = [
              java
              gradle
              kotlin
              intellij
              # gcc
              # ncurses
              # patchelf
              # zlib
              # libGL
              # xorg.libX11
              fontconfig
              ktfmt
              claude-code
            ];
            shellHook = ''
              export BASE_DIR=$(pwd)
              mkdir -p $BASE_DIR/.share

              if [ -L "$BASE_DIR/.share/java" ]; then
                unlink "$BASE_DIR/.share/java"
              fi
              ln -sf ${java}/lib/openjdk $BASE_DIR/.share/java

              if [ -L "$BASE_DIR/.share/gradle" ]; then
                unlink "$BASE_DIR/.share/gradle"
              fi
              ln -sf ${gradle}/lib/gradle $BASE_DIR/.share/gradle
              export GRADLE_HOME="$BASE_DIR/.share/gradle"

              export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${
                pkgs.lib.makeLibraryPath [
                  kotlin
                  pkgs.libGL
                  pkgs.xorg.libX11
                  pkgs.fontconfig
                ]
              };
            '';
          };
      }
    );
}
