let
  unstable = import (builtins.fetchGit {
    name = "nixos-unstable-2023-10-18";
    url = https://github.com/nixos/nixpkgs/;
    ref = "refs/heads/nixos-unstable";
    rev = "ca012a02bf8327be9e488546faecae5e05d7d749";
  }) {};
  shellname = "julia";
in
  unstable.mkShell {
    buildInputs = [
      unstable.julia
      unstable.gnuplot
    ];
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
      julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer");'
    '';
  }

# [https://github.com/julia-vscode/julia-vscode](julia-vscode)
# defines where current best LSP for Julia exists.
#
# This Can be installed with:
#
# ```sh
# julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer")'
# ```
# where ~/.julia/environments/nvim-lspconfig is the location where the default
# configuration expects LanguageServer.jl to be installed.
#
# To update an existing install, use the following command:
#
# ```sh
# julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.update()'
# ```
#
# Note: In order to have LanguageServer.jl pick up installed packages or
# dependencies in a Julia project, you must make sure that the project is
# instantiated:
#
# ```sh
# julia --project=/path/to/my/project -e 'using Pkg; Pkg.instantiate()'
# ```
