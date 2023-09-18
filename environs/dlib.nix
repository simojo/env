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
      if [[ -n $LD_LIBRARY_PATH ]]; then
        export LD_LIBRARY_PATH="${pkgs.bzip2.out}/lib:$LD_LIBRARY_PATH"
      else
        export LD_LIBRARY_PATH="${pkgs.bzip2.out}/lib"
      fi

      export LD_LIBRARY_PATH="${pkgs.alsa-lib.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.fontconfig.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.freetype.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.dlib.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libass.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.cudaPackages.cudnn}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.cudaPackages.libcublas}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.cudatoolkit}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.dav1d.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.dbus.lib}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.elfutils.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.ffmpeg.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.gcc-unwrapped.lib}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.fribidi.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.gfortran.cc.lib}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.glib.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.glibc}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.gmp.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.gnutls.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.gst_all_1.gst-plugins-base.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.gst_all_1.gstreamer.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.hdf5.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.lame.lib}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.brotli.lib}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libdeflate.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libdrm.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libffi.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.SDL2.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libidn2.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libjpeg.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libogg.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.harfbuzz.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libopus.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libpng.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libssh.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libtasn1.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libtheora.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libtiff.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libunistring.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libunwind.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libva.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libva.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libvdpau.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libvorbis.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libvpx.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.libwebp.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.nettle.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.numactl.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.ocl-icd.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.openblas.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.opencv.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.opencv}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.openexr.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.openjpeg.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.openssl.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.orc.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.p11-kit.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.pcre2.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.protobuf}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.soxr.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.speex.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.srt.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.x264.lib}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.x265.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.xorg.libXau}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.xorg.libXdmcp}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.xorg.libXext.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.xorg.libxcb}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.xvidcore.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.xz.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.zlib}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.zstd.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.pulseaudio.out}/lib:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${pkgs.zimg.out}/lib:$LD_LIBRARY_PATH"
    '';
  }
