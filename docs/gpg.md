# GPG

Notes about GPG  

```sh
# generating key
gpg --full-generate-key

# seeing existing keys
gpg --list-secret-keys --keyid-format LONG

# export key
gpg --export -a "KEYIDGOESHERE"
gpg --export-secret-key -a "KEYIDGOESHERE"

# delete key
gpg --delete-key "KEYIDGOESHERE"
gpg --delete-secret-key "KEYIDGOESHERE"
```

**Links**  

http://irtfweb.ifa.hawaii.edu/~lockhart/gpg/  
https://docs.github.com/en/github/authenticating-to-github/generating-a-new-gpg-key  
https://rtcamp.com/tutorials/linux/gpg-keys/  
