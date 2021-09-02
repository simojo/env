{ pkgs ? import <unstable> {} }:

let
  shellname = "hs";
  mods = with pkgs; [
    ghc
    haskellPackages.file-embed
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
