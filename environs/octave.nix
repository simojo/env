let
  unstable = import (builtins.fetchGit {
    name = "nixos-2025-11-28";
    url = "https://github.com/nixos/nixpkgs/";
    rev = "3635c3da55f74817efb43d4af48083d3aaade903";
  }) {};
  shellname = "octave";
in
  unstable.mkShell {
    buildInputs = [
      unstable.octave
    ];
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
    '';
  }
