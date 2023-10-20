# Pinning Nixpkgs

While the major selling point of Nix and NixOS is reproducibility, without
bothering to go through pinning the nixpkgs repository it's arguably not any
different than more traditional package or system management approaches.
Pinning nixpkgs can be slightly convoluted though, so this document was created
as something of a reference for various situations and approaches that can be
taken.  The takeaway here is essentially that *you probably want to pin
nixpkgs*.

* *Note:* [https://lazamar.co.uk/nix-versions/](https://lazamar.co.uk/nix-versions/) offers a means of "[finding] all versions of a package that were available in a channel and the revision [it can be downloaded from]."

## Pinning within `nix-shell` environments using `fetchTarball`

Normally, the intention is to pin against the latest version of the
`nixpkgs-unstable` channel, barring any issues that may present forcing you to
remain on an older version.  That can be accomplished by pulling the latest
commit hash via the first command below, and using it in the second hash to
calculate the sha256 and simultaneously cache the tarball to avoid having to
download the tarball twice.

```sh
git ls-remote https://github.com/nixos/nixpkgs-channels nixpkgs-unstable
nix-prefetch-url --unpack https://github.com/nixos/nixpkgs/archive/0j4m572dz6ak49mf3c0q4aq1z0qzm7qn08amygym27j55gh197zf.tar.gz
```

Afterwards, you drop the commit hash and sha256 into a `shell.nix` something
like this:

```nix
let
  shellname = "nix-shell-example";
  pkgs = import (builtins.fetchTarball {
    name = "nixpkgs-unstable-2020-02-15"; # descriptive, can be whatever
    url = https://github.com/nixos/nixpkgs/archive/f77e057cda60a3f96a4010a698ff3be311bf18c6.tar.gz;
    sha256 = "0j4m572dz6ak49mf3c0q4aq1z0qzm7qn08amygym27j55gh197zf";
  }) {};
in
  pkgs.stdenv.mkDerivation {
    name = shellname;
    buildInputs = [
      pkgs.bashInteractive
      pkgs.elixir
    ];
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
    '';
  }
```

Note that this is leaning on GitHub automatically generating and serving
tarballs of each commit.  Downloading these tarballs is significantly faster
than downloading the actual nixpkgs repository, as it doesn't include the Git
history, just the checkout.  If you didn't want to rely on GitHub you could
create a tarball of the desired checkout and host it somewhere yourself.

## Pinning within `nix-shell` environments using `fetchGit`

An alternative to the above `fetchTarball` approach is to use `fetchGit`, which
pulls the repository using Git instead.  You still pull the latest commit hash
with the first command as shown below, but needn't jump through the same sha256
hoops.

```sh
git ls-remote https://github.com/nixos/nixpkgs nixos-unstable
```

Afterwards, you drop the commit hash alone into a `shell.nix` something like
this, specifying the ref and URL:

```nix
let
  shellname = "nix-shell-example";
  pkgs = import (builtins.fetchGit {
    name = "nixpkgs-unstable-2020-02-15"; # descriptive, can be whatever
    url = https://github.com/nixos/nixpkgs/;
    ref = "refs/heads/nixos-unstable";
    rev = "f77e057cda60a3f96a4010a698ff3be311bf18c6";
  }) {};
in
  pkgs.stdenv.mkDerivation {
    name = shellname;
    buildInputs = [
      pkgs.bashInteractive
      pkgs.elixir
    ];
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
    '';
  }
```

In an environment where multiple machines need to pull a pinned nixpkgs version,
both the `fetchTarball` and the `fetchGit` approaches are suitable, it's just a
question of what tradeoffs you want to choose; `fetchTarball` has some initial
preparation that needs done, generating the tarballs, while `fetchGit` would
have higher data transfer and storage needs, but requires little preparation.

## Pinning multiple versions within `nix-shell` environments

Pinning multiple versions of nixpkgs within `nix-shell` environments is actually
incredibly straightforward, at least after the approaches for pinning nixpkgs in
the first place have been made less opaque:

```nix
let
  shellname = "nix-shell-example";
  pkgsStable = import (builtins.fetchTarball {
    name = "nixos-19.09-2020-02-15"; # descriptive, can be whatever
    url = https://github.com/nixos/nixpkgs/archive/8731aaaf8b30888bc24994096db830993090d7c4.tar.gz;
    sha256 = "1hcc89rxi47nb0mpk05nl9rbbb04kfw97xfydhpmmgh57yrp3zqa";
  }) {};
  pkgsUnstable = import (builtins.fetchTarball {
    name = "nixpkgs-unstable-2020-02-15"; # descriptive, can be whatever
    url = https://github.com/nixos/nixpkgs/archive/f77e057cda60a3f96a4010a698ff3be311bf18c6.tar.gz;
    sha256 = "0j4m572dz6ak49mf3c0q4aq1z0qzm7qn08amygym27j55gh197zf";
  }) {};
in
  pkgsStable.stdenv.mkDerivation {
    name = shellname;
    buildInputs = [
      pkgsStable.bashInteractive
      pkgsUnstable.elixir
    ];
    shellHook = ''
      export NIX_SHELL_NAME='${shellname}'
    '';
  }
```

You would follow the same pattern if you needed to pin further versions from
different places, say your own fork of nixpkgs.

## Pinning nixpkgs for `nixos-rebuild`

While the `configuration.nix` file covers the configuration necessary to rebuild
the system, it's silently dependent on the version of
[nixpkgs](https://github.com/NixOS/nixpkgs) being tracked through `nix-channel`.
Thus to enable more closely reproducible systems it's necessary to jump through
some additional hoops.  You'll first need a copy of the nixpkgs version you want
to use, either via `git clone`, or by downloading and extracting a tarball.  I'm
partial to biting the bullet and cloning the repository, as at some point you'll
likely want to dig into the history.

```sh
git clone https://github.com/NixOS/nixpkgs
```

Unfortunately, you can't effectively pin nixpkgs within the NixOS
`configuration.nix` because *reasons* so the suggested approach is to feed
`nixos-rebuild` a local checkout of the nixpkgs repository as an argument at
runtime, like so:

```sh
sudo nixos-rebuild switch -I nixpkgs=./nixpkgs
```

Then what version of nixpkgs you build the system against is dependent on what
commit you have checked out in that directory.  Since this separates the config
from the nixpkgs version you'll probably want to document what commit or hash
was used somewhere.  This is definitely an area that NixOS could improve; it
should be just as possible to pin nixpkgs for NixOS as nixpkgs for a `nix-shell`
environment and the reasons it isn't seem antithetical to the design.

