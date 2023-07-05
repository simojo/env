{ pkgs ? import <unstable> {} }:

let
  shellname = "dlib-dev";
  buildInpts = with pkgs; [
    cmake
    gcc
    python3
    cudatoolkit # nixos.wiki/wiki/CUDA
    cudaPackages.cudnn
    blas
    xorg.libX11
    pkg-config
  ];
in
  pkgs.stdenv.mkDerivation {
    name = shellname;
    buildInputs = [ buildInpts ];
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
      export X11_X11_INCLUDE_PATH='${pkgs.xorg.libX11.dev}/include'
      echo "[LOG] X11 library path set to $X11_X11_INCLUDE_PATH"
    '';
  }

# BUILDING: the following need to be run from dlib/examples/
  # 1. mkdir build; cd build
  # 2. cmake -DX11_X11_INCLUDE_PATH=$X11_X11_INCLUDE_PATH ..
  # 3. cmake --build .
# in line (2.) above, it is necessary to include `-DX11_X11_INCLUDE_PATH=$X11_X11_INCLUDE_PATH` because NixOS does not install executables in the predictable places that CMake would expect. That is why we have the assignment of the corresponding environment variable in the `shellHook`.
# CUDA (Compute Unified Device Architecture) is used for accessing GPU-instructions from a C-language interface. It is developed by NVIDIA.
