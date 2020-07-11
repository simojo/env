let
  inherit (import <nixpkgs> {}) fetchFromGitHub;
  nixpkgs = fetchFromGitHub {
    owner  = "NixOS";
    repo   = "nixpkgs";
    rev    = "173852b9362ba4055dc196ec4c66fe493e0489bb";
    sha256 = "1v9x7q9iqh5551dby4149igcqzs81h3xmnwyi2lwvdx4jrabs92k";
  };
  pkgs = import nixpkgs {};
  mytex = pkgs.texlive.combine {
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
      mytex
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

