{ pkgs ? import <unstable> {} }:

let
  shellname = "cpp";
  myCpp = with pkgs; [ cmake gcc python3 ];
in
  pkgs.stdenv.mkDerivation {
    name = shellname;
    buildInputs = [ myCpp ];
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
    '';
  }
