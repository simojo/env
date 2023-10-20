{ pkgs ? import <unstable> {} }:

let
  shellname = "dlib-dev";
  buildInpts = with pkgs; [
    alsa-lib
    blas
    bzip2
    cmake
    cudaPackages.cudnn
    cudaPackages.libcublas
    cudatoolkit # nixos.wiki/wiki/CUDA
    dav1d
    dlib
    elfutils
    ffmpeg
    ffmpeg.dev
    ffmpeg.out
    fontconfig
    freetype
    gcc
    gcc-unwrapped
    SDL2
    gfortran
    glib
    glibc
    gmp
    gnutls
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    hdf5
    lame
    lapack.dev
    lapack.out
    libass
    libdeflate
    libdrm
    libffi
    libidn2
    libjpeg
    libogg
    libopus
    libpng
    libssh
    libtasn1
    libtheora
    libtiff
    libunistring
    libunwind
    libva
    libva
    brotli
    libvdpau
    libvorbis
    libvpx
    libwebp
    nettle
    numactl
    ocl-icd
    openblas
    opencv
    openexr
    openjpeg
    harfbuzz
    openssl
    dbus
    orc
    p11-kit
    pcre2
    pkg-config
    protobuf
    pulseaudio
    fribidi
    python3
    soxr
    speex
    srt
    x264
    x265
    xorg.libX11
    xorg.libX11.dev
    xorg.libXau
    xorg.libXdmcp
    xorg.libXext
    xorg.libxcb
    xorg.xorgproto
    xvidcore
    xz
    zimg
    zlib
    zstd
  ];
in
  pkgs.stdenv.mkDerivation {
    name = shellname;
    buildInputs = [ buildInpts ];
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    shellHook = ''
      echo -e '\033[1;33m

      - BUILDING: the following need to be run from dlib/examples/
        1. mkdir build; cd build
        2. cmake -DX11_X11_INCLUDE_PATH=$X11_X11_INCLUDE_PATH ..
        3. cmake --build .
        - in line (2.) above, it is necessary to include -DX11_X11_INCLUDE_PATH=$X11_X11_INCLUDE_PATH
          because NixOS does not install executables in the predictable places that CMake would expect.
          That is why we have the assignment of the corresponding environment variable in the shellHook.
      - CUDA (Compute Unified Device Architecture) is used for accessing GPU-instructions
        from a C-language interface. It is developed by NVIDIA.
      - Download http://dlib.net/files/shape_predictor_68_face_landmarks.dat.bz2 and for facial landmark detection example
      \033[0m'

      export NIX_SHELL_NAME='${shellname}'
      export X11_X11_INCLUDE_PATH='${pkgs.xorg.libX11.dev}/include'
    '';
  }
