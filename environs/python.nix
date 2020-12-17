{ pkgs ? import (fetchTarball https://git.io/Jf0cc) {} }:

let
  shellname = "python";
  mach-nix = import (
  builtins.fetchGit {
      url = "https://github.com/DavHau/mach-nix/";
      ref = "2.0.0";
    }
  );

  mods = mach-nix.mkPython {
    python = pkgs.python37;
    requirements = ''
      flake8
      pydocstyle
    '';
  };
in
  pkgs.mkShell {
    name = shellname;
    buildInputs = [
      mods
    ];
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
      alias p='python3'
    '';
  }

