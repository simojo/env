let
  nixpkgs = import (fetchTarball ("channel:nixpkgs-unstable")) {};
  shellname = "rust";
in
  nixpkgs.mkShell {
    buildInputs = [
      nixpkgs.rustc
      nixpkgs.cargo
      nixpkgs.rustfmt
      nixpkgs.rust-analyzer
      nixpkgs.protocol # used for libp2p
    ];
    shellHook = ''
      export RUST_BACKTRACE=1 # is this important?
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
