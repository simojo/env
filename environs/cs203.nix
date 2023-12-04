let
  pkgs = import (builtins.fetchGit {
    name = "nixos-unstable-2023-10-18";
    url = https://github.com/nixos/nixpkgs/;
    ref = "refs/heads/nixos-unstable";
    rev = "ca012a02bf8327be9e488546faecae5e05d7d749";
  }) {};
  shellname = "cs203";
  buildInpts = with pkgs; [
    gcc-unwrapped.lib
    glibc
    glibc
    graphviz
    pipx
    poetry
    python311Packages.python-lsp-ruff
    python310
    python310Packages.ipykernel.dist
    python310Packages.ipython
    python310Packages.jupyter
    python310Packages.jupyterlab
    python310Packages.markdown
    python310Packages.pip
    python310Packages.rich
    python310Packages.virtualenv
    python311
    python311Packages.pip
    python311Packages.python-lsp-server
    quarto
    sqlite.dev
    stdenv.cc.cc.lib
  ];
in
  with pkgs.lib; pkgs.stdenv.mkDerivation {
    name = shellname;
    buildInputs = [ buildInpts ];
    runtimeDependencies = [ pkgs.stdenv.cc.cc.lib ];
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
      export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib"
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
