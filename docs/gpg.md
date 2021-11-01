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

```sh
# encrypt a file
gpg -o asdf.gpg -c asdf.txt

# decrypt a file
gpg --output asdf.txt -d asdf.gpg
# or
gpg asdf.gpg
```

**Links**  

http://irtfweb.ifa.hawaii.edu/~lockhart/gpg/  
https://docs.github.com/en/github/authenticating-to-github/generating-a-new-gpg-key  
https://rtcamp.com/tutorials/linux/gpg-keys/  
