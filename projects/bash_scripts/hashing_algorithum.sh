#!/bin/bash
# write a bash script for different hashing algorithum 
read -p "Enter password: " password

echo "MD5: $(echo -n "$password" | md5sum | cut -d' ' -f1)"
echo
echo "SHA-1: $(echo -n "$password" | sha1sum | cut -d' ' -f1)"
echo
echo "SHA-224: $(echo -n "$password" | sha224sum | cut -d' ' -f1)"
echo
echo "SHA-256: $(echo -n "$password" | sha256sum | cut -d' ' -f1)"
echo
echo "SHA-384: $(echo -n "$password" | sha384sum | cut -d' ' -f1)"
echo
echo "SHA-512: $(echo -n "$password" | sha512sum | cut -d' ' -f1)"
echo
echo "RIPEMD-160: $(echo -n "$password" | openssl ripemd160 | cut -d' ' -f2)"
echo
echo "Whirlpool: $(echo -n "$password" | whirlpooldeep)"
echo
echo "BLAKE2: $(echo -n "$password" | b2sum | cut -d' ' -f1)"
echo
echo "PBKDF2 (Password-Based Key Derivation Function 2): $(echo -n "$password" | openssl passwd -6 -stdin)"
echo
echo "HMAC (Keyed-Hashing for Message Authentication Code): $(echo -n "$password" | openssl dgst -sha256 -hmac "mykey" | cut -d' ' -f2)"
echo
echo "LM Hash: $(echo -n "$password" | openssl passwd -1 -stdin)"
echo
echo "NTLM Hash: $(echo -n "$password" | iconv -t utf16le | openssl dgst -md4 | cut -d' ' -f2)"
