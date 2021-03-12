{ pkgs ? import <unstable> {} }:
let
  myTex = with pkgs; [
    tectonic
    biber
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
# ---
# title: "Habits"
# author: John Doe
# date: March 22, 2005
# geometry: "left=3cm,right=3cm,top=2cm,bottom=2cm"
# output: pdf_document
# ---

# https://oeis.org/wiki/List_of_LaTeX_mathematical_symbols
