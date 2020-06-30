# Notes from NixOS on ZFS bootstrapping of `sv0`

* the device itself is a Lenovo m90n IoT server, which has an Intel i3-8145U
dual-core processor, dual gigabit NICs, and several high-bandwidth USB-C ports;
outfitted with dual 2TB Intel 665p NVME drives that were on sale at the time.
* there are significantly cheaper ways to get better hardware, but this setup
has the advantage of being fanless with no moving parts and of being extremely
compact, which fits well with the rest of the networking equipment.
* since encrypted boot partitions aren't well supported in conjunction with ZFS,
the boot partition will live outside the encrypted ZFS pool; consequentially, it
won't benefit from being protected via encryption nor the ZFS integrity checks.
* you could consider placing that on an external device of some kind, but that's
an awfully deep rabbit hole to dive down and while interesting has the tendency
to produce extremely brittle systems if followed to it's natural conclusion.
* along similar lines, only one of the two internal NVME drives will have a boot
partition, which isn't great for redundancy but mirrored boot partitions aren't
well supported and it gets back to the brittleness vs reliability argument.
* this is not meant to be copy-pastable, various options are chosen that may not
be ideally suited for your hardware or intentions, this is meant more as a quick
guide for myself should the need ever arise to reinstall from scratch.
* docs and blogs are your friend:
  * <https://nixos.org/nixos/manual/index.html#ch-installation>
  * <https://grahamc.com/blog/nixos-on-zfs>
  * <https://grahamc.com/blog/erase-your-darlings>
  * <https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/>
  * <https://github.com/nix-community/impermanence>
  * <https://nixos.org/nixos/options.html>
  * <https://nixos.wiki/wiki/NixOS_on_ZFS>
  * <https://wiki.archlinux.org/index.php/ZFS>
  * <https://en.wikipedia.org/wiki/ZFS>

```sh
# prepare the installation media
curl https://channels.nixos.org/nixos-20.03/latest-nixos-minimal-x86_64-linux.iso > nixos.iso
sudo dd if=nixos.iso of=/dev/sda # do a lsblk/fdisk to determine the correct device.
```

```sh
# boot from the installation media

# become root to avoid sudo-stutter
sudo su

# partitioning
disk1=/dev/disk/by-id/nvme-INTEL_SSDPEKNW020T9_BTNR00161UPU2P0C
disk2=/dev/disk/by-id/nvme-INTEL_SSDPEKNW020T9_BTNR00161UQ92P0C
dd if=/dev/urandom of=$disk1
dd if=/dev/urandom of=$disk2
parted $disk1 -- mklabel gpt
parted $disk1 -- mkpart primary 512MiB -6GiB
parted $disk1 -- mkpart primary linux-swap -6GiB 100%
parted $disk1 -- mkpart ESP fat32 1MiB 512MiB
parted $disk1 -- set 3 boot on
parted $disk2 -- mklabel gpt
parted $disk2 -- mkpart primary 512MiB 100%
lsblk

# ZFS pool setup
zpool create \
  -R /mnt \
  -O atime=off \
  -O acltype=posixacl \
  -O xattr=sa \
  -O mountpoint=none \
  -O encryption=aes-256-gcm \
  -O keyformat=passphrase \
  zpuddle \
  $disk1-part1 \
  $disk2-part1 \
  -f
zpool status
zfs list

# ZFS datasets setup
alias zcl='zfs create -o mountpoint=legacy'
zcl zpuddle/ephem
zcl zpuddle/ephem/nix
zcl zpuddle/ephem/root
zcl zpuddle/persist
for fs in backups deprecated docker dockervols projects scratch; do
  zcl zpuddle/persist/$fs
done
zfs list

# snapshots while they're empty
zfs snapshot zpuddle/ephem/{nix,root}@blank
zfs snapshot zpuddle/ephem@blank
zfs snapshot zpuddle/persist/{backups,deprecated,docker,dockervols,projects,scratch}@blank
zfs snapshot zpuddle/persist@blank
zfs snapshot zpuddle@blank
zfs list -t snapshot

# mounting the various datasets
mount -t zfs zpuddle/ephem/root /mnt
mkdir /mnt/{nix,_backups,_deprecated,_docker,_dockervols,_projects,_scratch}
mount -t zfs zpuddle/ephem/nix /mnt/nix
for fs in backups deprecated docker dockervols projects scratch; do
  mount -t zfs zpuddle/persist/$fs /mnt/_$fs
done
mkfs.vfat -F 32 -n boot $disk1-part3 && mkdir /mnt/boot && mount $disk1-part3 /mnt/boot
mkswap -L swap $disk1-part2 && swapon $disk1-part2
ll /mnt

# generate initial configuration
nixos-generate-config --root /mnt
# at this point if reinstalling you would pull existing configuration.nix, merging uuids.

# otherwise, there are a few steps you'll need to take for ZFS;
# add `"elevator=none"` to `boot.kernelParams`, is a ZFS disk scheduler thing.
# set `networking.hostId` to `head -c4 /dev/urandom | od -A none -t x4`
# set `boot.supportedFilesystems` to `[ "zfs" ]`
# set `boot.zfs.defNodes` to `"/dev/disk/by-partuuid"``

# probably also want to include vim/git/curl/etc so they're available post-install.
# probably want your /etc/nixos directory under version control, and backed up asap.
# I've always just merged the `configuration.nix` and `hardware-configuration.nix`.

nixos-install
poweroff
# remove installation media, power-on.
```

```sh
# login as root
nix-channel --add https://nixos.org/channels/nixos-unstable nixos
nix-channel --update
nixos-rebuild switch
reboot
```

```nix
# optional; approach from <https://grahamc.com/blog/erase-your-darlings>
{
  # nuke '/' on reboot, but leave the nix-store and persisted datasets.
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r zpuddle/ephem/root@blank
  '';
  # move /etc/nixos/configuration.nix under one of the persisted datasets;
  # then preload the link to it for the first nixos-rebuild switch.
  # ln -s /_projects/configuration.nix /etc/nixos/configuration.nix
  systemd.tmpfiles.rules = [
    "L /etc/nixos/configuration.nix - - - - /_projects/env/nixconfigs/sv0_configuration.nix"
  ];
  users.mutableUsers = false;
  # shadow entries will be gone post-rollback, so need to sideload them;
  # nix-env -i mkpasswd; mkpasswd -m sha-512 -s >> /_projects/secrets/sv0_passwd_root
  # nix-env -i mkpasswd; mkpasswd -m sha-512 -s >> /_projects/secrets/sv0_passwd_nonroot
  users.root.passwordFile = "/_projects/secrets/sv0_passwd_root";
  users.nonroot.passwordFile = "/_projects/secrets/sv0_passwd_nonroot";
  # flag as neededForBoot as some required things may be placed here to persist them.
  fileSystems."/_projects" = { device = "zpuddle/persist/projects"; fsType = "zfs"; neededForBoot = true; };
  # instruct docker to store things where they won't be nuked.
  virtualisation.docker.extraOptions = "--data-root=/_docker";
}
```

> see the docker docs for setup related to docker that probably would need to be
> done afterwards; once complete, would restore data from backups most likely.

