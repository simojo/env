# Maintenance

* See `docs/backups.md`.
* See `docs/docker.md`.

## Nix & NixOS

```sh
nix-env -q                     # list installed packages
nix-env -qa                    # list available packages
nix-env -qa | fzf              # often helpful to pipe into `fzf`
nix search curl                # search the package registry
nix-env -i curl                # install (--install also works)
nix-env -e curl                # uninstall (--uninstall also works)
nix-env --list-generations     # list the recorded generations
nix-env --rollback             # rollback to a particular generation
nix-env --delete-generations   # drop generations: [3 4 9 | old | 30d]
nix-env -i '*'                 # periodically move things to environment.systemPackages
sudo nixos-rebuild switch      # rebuild, setting the new generation as Grub default
sudo nixos-rebuild test        # rebuild, but do not make it the Grub default
# FIXME: updating nixpkgs/channels.
```

## ZFS

```sh
zpool status
zpool scrub zpuddle
zfs list
```

