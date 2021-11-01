# Network

Notes about managing network connections  

```sh
# connecting to WPA2 enterprise
nmcli connection add \
 type wifi con-name "MySSID" ifname INTERFACENAME ssid "MySSID" -- \
 wifi-sec.key-mgmt wpa-eap 802-1x.eap ttls \
 802-1x.phase2-auth mschapv2 802-1x.identity "USERNAME"
```

**Links**  

https://unix.stackexchange.com/questions/145366/how-to-connect-to-an-802-1x-wireless-network-via-nmcli  
