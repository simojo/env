{ pkgs ? import <unstable> {} }:

let
  shellname = "c";
  myC = with pkgs; [ gcc python3 ];
in
  pkgs.stdenv.mkDerivation {
    name = shellname;
    buildInputs = [ myC ];
    RUST_BACKTRACE = 1;
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
      # usage:
      # $ ls
      # asdf.c
      # $ gccwrap asdf
      # $ ls
      # asdf.c
      # asdf (exec)
      # can only take a single argument
      gccwrap() {
        fname="$1"
        execname="deleteme"
        gcc -Wall -g "$fname" -o "$execname"
        ./$execname $2
        rm $execname
      }

    '';
  }
