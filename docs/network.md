# Network

Notes about managing network connections  

```sh
# connecting to WPA2 enterprise
nmcli connection add \
 type wifi con-name "MySSID" ifname INTERFACENAME ssid "MySSID" -- \
 wifi-sec.key-mgmt wpa-eap 802-1x.eap EAPTYPE \
 802-1x.phase2-auth mschapv2 802-1x.identity "USERNAME"
```

* Note: EAPTYPE is usually peap for Eduroam and other .edu enterprise networks.


```sh
# connecting to WPA2 enterprise (method 2)
nmcli con add type wifi ifname IFNAME con-name CONNNAME ssid SSID
nmcli con edit id CONNNAME
nmcli> set ipv4.method auto
nmcli> set 802-1x.eap peap
nmcli> set 802-1x.phase2-auth mschapv2
nmcli> set 802-1x.identity USERNAME
nmcli> set 802-1x.password PASSWORD
nmcli> set wifi-sec.key-mgmt wpa-eap
nmcli> save
nmcli> activate
# (Press C-d to exit upon success)
```

**Links**  

https://unix.stackexchange.com/questions/145366/how-to-connect-to-an-802-1x-wireless-network-via-nmcli  
