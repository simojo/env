{ pkgs ? import <unstable> {} }:

let
  shellname = "cs203";
  python-lsp-ruff = pkgs.python311.pkgs.buildPythonPackage rec {
    pname = "python-lsp-ruff";
    version = "1.4.0";
    format = "pyproject";
    disabled = pkgs.python311.pkgs.pythonOlder "3.7";
    src = pkgs.fetchPypi {
      inherit version;
      pname = "python-lsp-ruff";
      sha256 = "sha256-TqTeQc/lT5DcPcJbZXbEiUGbYjFP8idpzdSZlXD59Y4=";
    };
    postPatch = ''
      # ruff binary is used directly, the ruff python package is not needed
      sed -i '/"ruff>=/d' pyproject.toml
      sed -i 's|sys.executable, "-m", "ruff"|"${pkgs.ruff}/bin/ruff"|' pylsp_ruff/plugin.py
    '';

    propagatedBuildInputs = [
      pkgs.python311Packages.lsprotocol
      pkgs.python311Packages.python-lsp-server
      pkgs.python311
      pkgs.python311Packages.tomli
    ];

    doCheck = true;
  };
  buildInpts = with pkgs; [
    graphviz
    pipx
    poetry
    python310
    python310Packages.pip
    python310Packages.rich
    python310Packages.jupyter
    python310Packages.ipython
    python310Packages.ipykernel
    python310Packages.ipykernel.dist
    python310Packages.jupyterlab
    python310Packages.markdown
    python311
    python311Packages.pip
    python311Packages.python-lsp-server
    python-lsp-ruff
    quarto
    ruff
    pkgs.gcc-unwrapped.lib
    sqlite.dev
  ];
in
  pkgs.stdenv.mkDerivation {
    name = shellname;
    buildInputs = [ buildInpts python-lsp-ruff ];
    shellHook = ''
      export LD_LIBRARY_PATH="${pkgs.gcc-unwrapped.lib}/lib:$LD_LIBRARY_PATH"

      echo -e '\033[1;33m
      This is a shell for CMPSC 203: Software Engineering at Allegheny College
      \033[0m'
    '';
  }

# USING JUPYTER
# I've found that in order to use Jupyter, it makes more sense to install the necessary packages from within jupyter notebook itself.
# every professional Précis
# Summary of content
# What content means to you
# action items what you should 1. Stop doing, 2. Start doing, 3. Keep doing
