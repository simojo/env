{ pkgs ? import <unstable> {} }:

let
  shellname = "rust";
  myRust = with pkgs; [ rustc cargo rustfmt rust-analyzer ];
in
  pkgs.stdenv.mkDerivation {
    name = shellname;
    buildInputs = [ myRust ];
    RUST_BACKTRACE = 1;
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
      alias cb='cargo build'
      alias cf='cargo fmt'
      alias cr='cargo run'
      alias ct='cargo test'
      alias cu='cargo update'
      alias ci='cargo install'
      alias cui='cargo uninstall'
    '';
  }
