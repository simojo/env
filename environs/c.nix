{ pkgs ? import <unstable> {} }:

let
  shellname = "c";
  myC = with pkgs; [ gcc ];
in
  pkgs.stdenv.mkDerivation {
    name = shellname;
    buildInputs = [ myC ];
    RUST_BACKTRACE = 1;
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
      gccwrap() {
        fname="$1"
        execname=${fname::-2}
        gcc -Wall -g "$fnmae" -o "$execname"
      }
    '';
  }
