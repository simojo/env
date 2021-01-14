{ pkgs ? import <unstable> {} }:

let
  shellname = "python";
  # NOTE: backup if nix's packaging doesn't work
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
  myPython = with pkgs; [
    python38Full
    python38Packages.pylint
    python38Packages.black
    python38Packages.pytest
    python38Packages.six
    python38Packages.codecov
    python38Packages.flake8
    python38Packages.pytestcov
    python38Packages.pytest-sugar
    # python38Packages.neovim
    python38Packages.bandit
    # python38Packages.codacy-coverage
    python38Packages.pydocstyle
    # python38Packages.radon
    # python38Packages.xenon
    # python38Packages.snoop
    elixir
  ];
in
  pkgs.stdenv.mkDerivation {
    name = shellname;
    buildInputs = [
      myPython
    ];
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
      alias p='python3'
    '';
  }

