let
  pkgs = import (fetchTarball ("channel:nixpkgs-unstable")) {};
  shellname = "hs";
  mods = with pkgs; [
    ghc
    haskell-language-server
    cabal-install
  ];
in
  pkgs.stdenv.mkDerivation {
    name = shellname;
    buildInputs = [
      mods
    ];
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
    '';
  }
