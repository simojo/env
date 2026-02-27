let
  nixpkgs = import (builtins.fetchGit {
    name = "nixos-unstable-2023-10-18";
    url = "https://github.com/nixos/nixpkgs/";
    ref = "refs/heads/nixos-unstable";
    rev = "ca012a02bf8327be9e488546faecae5e05d7d749";
  }) {};
  shellname = "kicad";
in
  nixpkgs.mkShell {
    buildInputs = [
      nixpkgs.kicad
    ];
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
    '';
  }
