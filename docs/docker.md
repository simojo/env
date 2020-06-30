
# Docker

Quick-reference for working with the Docker instance running on a fanless Lenovo
m90n IoT server on the local network running NixOS on ZFS.  Slightly complicated
by wanting to handle firewalling through the Netgate SG-5100 pfsense box; the
server has two separate ethernet runs (one for the macvlans, one for management)
back to the pfsense router.  Using macvlans allows the containers to appear to
pfsense as separate physical machines; a consequence of that is that routing
between the machines happens via roundtrip through the pfsense box rather than
virtualized within the docker host.

```sh
# setting up the macvlan network;
docker network create -d macvlan --subnet=172.16.1.0/24 --gateway=172.16.1.1 -o parent=enp2s0 macnet
```

```sh
# binding new containers to the static IPs afterwards;
docker run -t -d --network=macnet --ip=172.16.1.choose --restart=unless-stopped --name=choose choose:latest
# within pfsense services > dhcp server > lan, add static dhcp mapping, so DHCP doesn't assign it.
# within pfsense services > dns resolver, add appropriate host overrides.
# either create and use a TLS cert from pfsense or route through proxy.
```

> FIXME: registry setup

> FIXME: process for updating containers

```sh
# UniFi controller setup:
docker run -t -d --network=macnet --ip=172.16.1.3 --restart=unless-stopped --name=unifi -e MEM_LIMIT=1024M linuxserver/unifi-controller:latest
```

