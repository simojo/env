let
  # FIXME: need to look into
  # https://blog.hackeriet.no/packaging-python-script-for-nixos/
  nixpkgs = import (fetchTarball ("channel:nixpkgs-unstable")) {};
  shellname = "vhdl";
  # https://github.com/ghdl/ghdl/tree/master/pyGHDL/lsp
  ghdl-ls = nixpkgs.buildPythonPackage {
    name = "ghdl-ls";
    src = builtins.fetchFromGithub {
      owner = "ghdl";
      repo = "ghdl";
    };
  };
in
  nixpkgs.mkShell {
    buildInputs = [
      nixpkgs.ghdl
      nixpkgs.gcc
      nixpkgs.dwfv
      nixpkgs.gtkwave
    ];
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
    '';
    buildPhase = ''
    '';
  }
