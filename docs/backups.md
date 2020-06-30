# Backups

* workhorse devices exclusively have quality NVME drives.
* workhorse devices ...FIXME...
* periodic ZFS scrubs for data integrity.
* periodic ZFS snapshots sent to the on-premises ZFS server.
* periodic downloads of backupfiles from pfsense and unifi.
* periodic backups to onsite external SSDs, rotated with offsite ones.
* reproducible environment configurations through NixOS.

```sh
# Initial setup of 1TB Samsung T5 Portable SSDs
sudo lsblk
sudo dd if=/dev/zero of=/dev/sda bs=1M
sudo parted /dev/sda mklabel gpt
sudo parted /dev/sda mkpart primary ext4 0% 100%
sudo mkfs.ext4 /dev/sda1
# FIXME: crypto.
```

```sh
# Initial setup of 256GB Samsung Evo Plus MicroSDs
sudo lsblk
sudo dd if=/dev/zero of=/dev/mmcblk0 bs=1M
sudo parted /dev/mmcblk0 mklabel gpt
sudo parted /dev/mmcblk0 mkpart primary ext4 0% 100%
sudo mkfs.ext4 /dev/mmcblk0p1
# FIXME: crypto.
```

