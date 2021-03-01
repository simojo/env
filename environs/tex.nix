{ pkgs ? import <unstable> {} }:
let
  myTex = with pkgs; [
    tectonic
  ];
  shellname = "latex";
in
  pkgs.stdenv.mkDerivation {
    name = shellname;
    buildInputs = [
      myTex
    ];
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
      alias p='pandoc -o out.pdf --pdf-engine tectonic'
    '';
  }

# This yaml header helps
# ---
# title: 'Title'
# author: Simon Jones
# geometry: margin=4cm
# output: pdf_document
# fontsize: 12pt
# ---

