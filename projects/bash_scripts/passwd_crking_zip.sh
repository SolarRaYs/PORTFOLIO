#!/bin/bash
# Bash script to crack the password of a ZIP file using zip2john and John the Ripper

# Specify the path to the wordlist file
wordlist_path="/home/parrot/wordlist1.txt"

# Prompt user to enter the ZIP file location
echo "Enter the path to the ZIP file:"
read zip_path

# Check if entered path is empty
if [ -z "$zip_path" ]; then
    echo "Error: No path entered."
    exit 1
fi

# Check if the file exists
if [ ! -f "$zip_path" ]; then
    echo "Error: '$zip_path' does not exist or is not a file."
    exit 1
fi

# Use zip2john to extract the hash
hash=$(zip2john "$zip_path" | grep -Eo '\*\$.*')

# Check if the hash extraction was successful
if [ -z "$hash" ]; then
    echo "Error: Failed to extract hash from ZIP file."
    exit 1
fi

# Convert the hash to a format that John the Ripper understands
converted_hash=$(echo "$hash" | sed 's/zip2/zip/')

# Attempt to crack the password using John the Ripper
echo "Attempting to crack the password for hash: $hash"
echo "$converted_hash" | john --pot=john_zip.pot --stdin "$wordlist_path"
