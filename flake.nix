{
  description = "Starter dev templates";

  outputs = { self }:
    let
      mkWelcomeText = { name, description, path, buildTools ? null
        , additionalSetupInfo ? null, }: {
          inherit path;

          description = name;

          welcomeText = ''
            # ${name}
            ${description}

            ${if buildTools != null then ''
              Comes bundled with:
              ${builtins.concatStringsSep ", " buildTools}
            '' else
              ""}
            ## Other tips
            If you use direnv run:

            ```
                echo "use flake" > .envrc
            ```
          '';
        };
    in {
      templates = {
        empty = mkWelcomeText {
          name = "Empty Template";
          description = ''
            A simple flake that provides a devshell
          '';
          path = ./empty;
        };
        rust = mkWelcomeText {
          path = ./rust;
          name = "Rust Template";
          description = ''
            A basic rust application template with a package build.
          '';
          buildTools = [ "All essential rust tools" "rust-analyzer" ];
        };
        zig = mkWelcomeText {
          path = ./zig;
          name = "Zig Template";
          description = ''
            A basic Zig application template with a package build.
          '';
          buildTools = [ "zig" "zls" ];
        };
        go = mkWelcomeText {
          path = ./go;
          name = "Go template";
          description = "A basic go project";
          buildTools = [ "go" "gopls" ];
        };
        python = mkWelcomeText {
          path = ./python;
          name = "Python Template";
          description = ''
            A basic python project
          '';
          buildTools = [ "python310" ];
        };
        nextjs = mkWelcomeText {
          path = ./nextjs;
          name = "NextJS Template";
          description = ''
            A basic NextJS application template with a package build.
          '';
          buildTools = [ "nodejs" "pnpm" ];
        };
      };
    };
}
