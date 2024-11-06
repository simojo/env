let
  unstable = import (builtins.fetchGit {
    name = "nixos-unstable-2024-10-09";
    url = "https://github.com/nixos/nixpkgs/";
    ref = "refs/heads/nixos-unstable";
    rev = "c31898adf5a8ed202ce5bea9f347b1c6871f32d1";
  }) {};
  shellname = "typst";
in
  unstable.mkShell {
    buildInputs = [
      unstable.typst
      unstable.tinymist
    ];
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
    '';
  }
