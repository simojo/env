{ pkgs ? import <unstable> {} }:

let
  # NOTE: backup if nix's packaging doesn't work
  # mach-nix = import (
  # builtins.fetchGit {
  #     url = "https://github.com/DavHau/mach-nix/";
  #     ref = "2.0.0";
  #   }
  # );
  # mods = mach-nix.mkPython {
  #   python = pkgs.python37;
  #   requirements = ''
  #     flake8
  #     pydocstyle
  #   '';
  # };
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
    # python38Packages.neovim <- doesn't work
    python38Packages.bandit
    # python38Packages.codacy-coverage <- doesn't work
    python38Packages.pydocstyle
    # python38Packages.radon <- doesn't work
    # python38Packages.xenon <- doesn't work
    # python38Packages.snoop <- doesn't work
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

