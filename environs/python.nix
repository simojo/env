{ pkgs ? import <unstable> {} }:
let
  shellname = "python";
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
    python38Packages.bandit
    python38Packages.pydocstyle
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
