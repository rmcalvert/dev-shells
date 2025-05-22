{
  description = "Starter dev templates";

  outputs =
    { self }:
    let
      mkWelcomeText =
        {
          name,
          description,
          path,
          buildTools ? null,
          additionalSetupInfo ? null,
        }:
        {
          inherit path;

          description = name;

          welcomeText = ''
            # ${name}
            ${description}

            ${
              if buildTools != null then
                ''
                  Comes bundled with:
                  ${builtins.concatStringsSep ", " buildTools}
                ''
              else
                ""
            }
            ## Other tips
            If you use direnv run:

            ```
                echo "use flake" > .envrc
            ```
          '';
        };
    in
    {
      templates = {
        empty = mkWelcomeText {
          name = "Empty Template";
          description = ''
            A simple flake that provides a devshell
          '';
          path = ./empty;
        };
        kotlin = mkWelcomeText {
          path = ./kotlin;
          name = "Kotlin Template";
          description = ''
            A basic kotlin application template with a package build.
          '';
          buildTools = [
            "All essential kotlin tools"
          ];
        };
        rust = mkWelcomeText {
          path = ./rust;
          name = "Rust Template";
          description = ''
            A basic rust application template with a package build.
          '';
          buildTools = [
            "All essential rust tools"
            "rust-analyzer"
          ];
        };
        ruby = mkWelcomeText {
          path = ./ruby;
          name = "Ruby Template";
          description = ''
            A basic ruby application template with a package build.
          '';
          buildTools = [
            "All essential ruby tools"
            "bundler"
          ];
        };
        zig = mkWelcomeText {
          path = ./zig;
          name = "Zig Template";
          description = ''
            A basic Zig application template with a package build.
          '';
          buildTools = [
            "zig"
            "zls"
          ];
        };
        n8n = mkWelcomeText {
          path = ./n8n;
          name = "n8n template";
          description = "A basic n8n template";
          buildTools = [
            "n8n"
          ];
        };
        go = mkWelcomeText {
          path = ./go;
          name = "Go template";
          description = "A basic go project";
          buildTools = [
            "go"
            "gopls"
          ];
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
          buildTools = [
            "nodejs"
            "pnpm"
          ];
        };
        tanstack = mkWelcomeText {
          path = ./tanstack;
          name = "Tanstack Template";
          description = ''
            A basic Tanstack Start application template with a package build.
          '';
          buildTools = [
            "nodejs"
            "pnpm"
          ];
        };
      };
    };
}
