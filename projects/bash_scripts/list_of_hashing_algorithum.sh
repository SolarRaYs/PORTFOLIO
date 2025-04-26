#!/bin/bash
# write a bash script to create different hashing algorithum and save in the seperate file based on the hashing type
# Prompt the user to enter the path to the password file
read -p "Enter the path to the password file: " PASSWORD_FILE

# Define output files
MD5_OUTPUT_FILE="passwords_md5.txt"
SHA1_OUTPUT_FILE="passwords_sha1.txt"
SHA224_OUTPUT_FILE="passwords_sha224.txt"
SHA256_OUTPUT_FILE="passwords_sha256.txt"
SHA512_OUTPUT_FILE="passwords_sha512.txt"
RIPEMD160_OUTPUT_FILE="passwords_ripemd160.txt"
WHIRLPOOL_OUTPUT_FILE="passwords_whirlpool.txt"
BLAKE2_OUTPUT_FILE="passwords_blake2.txt"
PBKDF2_OUTPUT_FILE="passwords_pbkdf2.txt"
HMAC_OUTPUT_FILE="passwords_hmac.txt"
LM_HASH_OUTPUT_FILE="passwords_lmhash.txt"
NTLM_HASH_OUTPUT_FILE="passwords_ntlmhash.txt"

# Check if the password file exists
if [[ ! -f $PASSWORD_FILE ]]; then
  echo "Password file '$PASSWORD_FILE' not found!"
  exit 1
fi

# Clear the output files if they already exist
> $MD5_OUTPUT_FILE
> $SHA1_OUTPUT_FILE
> $SHA224_OUTPUT_FILE
> $SHA256_OUTPUT_FILE
> $SHA512_OUTPUT_FILE
> $RIPEMD160_OUTPUT_FILE
> $WHIRLPOOL_OUTPUT_FILE
> $BLAKE2_OUTPUT_FILE
> $PBKDF2_OUTPUT_FILE
> $HMAC_OUTPUT_FILE
> $LM_HASH_OUTPUT_FILE
> $NTLM_HASH_OUTPUT_FILE

# Define HMAC key (example key, can be changed)
HMAC_KEY="secretkey"

# Read each password and create hashes
while IFS= read -r password; do
  if [[ -n "$password" ]]; then
    md5_hash=$(echo -n "$password" | md5sum | awk '{print $1}')
    sha1_hash=$(echo -n "$password" | sha1sum | awk '{print $1}')
    sha224_hash=$(echo -n "$password" | sha224sum | awk '{print $1}')
    sha256_hash=$(echo -n "$password" | sha256sum | awk '{print $1}')
    sha512_hash=$(echo -n "$password" | sha512sum | awk '{print $1}')
    ripemd160_hash=$(echo -n "$password" | openssl dgst -ripemd160 | awk '{print $2}')
    whirlpool_hash=$(echo -n "$password" | openssl dgst -whirlpool | awk '{print $2}')
    blake2_hash=$(echo -n "$password" | b2sum | awk '{print $1}')
    pbkdf2_hash=$(echo -n "$password" | openssl enc -pbkdf2 -md sha256 -salt -pass pass:"$password" | xxd -p)
    hmac_hash=$(echo -n "$password" | openssl dgst -sha256 -hmac "$HMAC_KEY" | awk '{print $2}')
    
    # LM Hash and NTLM Hash
    lm_hash=$(echo -n "$password" | iconv -f utf8 -t utf16le | openssl dgst -md4 | awk '{print $2}')
    ntlm_hash=$(echo -n "$password" | iconv -f utf8 -t utf16le | openssl dgst -md4 | awk '{print $2}')

    echo "$password:$md5_hash" >> $MD5_OUTPUT_FILE
    echo "$password:$sha1_hash" >> $SHA1_OUTPUT_FILE
    echo "$password:$sha224_hash" >> $SHA224_OUTPUT_FILE
    echo "$password:$sha256_hash" >> $SHA256_OUTPUT_FILE
    echo "$password:$sha512_hash" >> $SHA512_OUTPUT_FILE
    echo "$password:$ripemd160_hash" >> $RIPEMD160_OUTPUT_FILE
    echo "$password:$whirlpool_hash" >> $WHIRLPOOL_OUTPUT_FILE
    echo "$password:$blake2_hash" >> $BLAKE2_OUTPUT_FILE
    echo "$password:$pbkdf2_hash" >> $PBKDF2_OUTPUT_FILE
    echo "$password:$hmac_hash" >> $HMAC_OUTPUT_FILE
    echo "$password:$lm_hash" >> $LM_HASH_OUTPUT_FILE
    echo "$password:$ntlm_hash" >> $NTLM_HASH_OUTPUT_FILE
  fi
done < "$PASSWORD_FILE"

echo "Hashes have been written to the respective files."
