let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/04220ed6763637e5899980f98d5c8424b1079353.tar.gz";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in
  pkgs.mkShell {
    packages = with pkgs; [
      (python311.withPackages (ps: with ps; [
        bibtexparser
        csscompressor
        htmlmin
        pyyaml
        rich
        rjsmin
        jupyterlab
        jupyterlab-git
        pip
        pydocstyle
        quarto
      ]))
      (rustPlatform.buildRustPackage rec {
        pname = "minify-html";
        version = "v0.15.0";

        nativeBuildInputs = [
          python3
          clang
          llvmPackages.libclang.lib
        ];

        src = fetchFromGitHub {
          owner = "wilsonzlin";
          repo = pname;
          rev = version;
          sha256 = "sha256-X9JEwUiZdJ4qYT+ccQ8+6kpsYoTDJpEILA8NAD81LDs=";
        };

        LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib";

        cargoPatches = [
          ./add-Cargo.lock.patch
        ];

        cargoHash = "sha256-Nx4+kJvkgMwzJ+1HAA76nNUmRuJH2XIiU61JgKPUiRs=";
      })
      git
      pipx
      poetry
      prettierd
      python3
      quarto
      zsh
    ];
  shellHook = ''
    echo "✨ Running Quarto Preview with the 'develop' profile"
    quarto preview --profile develop
  '';
  }
