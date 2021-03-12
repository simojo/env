{ pkgs ? import <unstable> {} }:
let
  myTex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
    scheme-basic
    collection-latexextra
    collection-fontsextra
    collection-fontsrecommended
    collection-bibtexextra
    latexmk
    beamer;
  };
  shellname = "latex";
in
  pkgs.stdenv.mkDerivation {
    name = shellname;
    buildInputs = [
      myTex
      pkgs.python2
      pkgs.python27Packages.pygments
      pkgs.bashInteractive
    ];
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
    '';
  }

# (this was rather less than intuitive to figure out)
# https://nixos.org/nixpkgs/manual/#sec-language-texlive
# https://github.com/NixOS/nixpkgs/tree/master/pkgs/tools/typesetting/tex/texlive
# https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/tools/typesetting/tex/texlive/pkgs.nix

