#!/bin/bash
# Bash script to crack the password of a PDF file using pdf2john and John the Ripper

# Prompt user to enter the PDF file location
echo "Enter the path to the password-protected PDF file:"
read pdf_path

# Check if entered path is empty
if [ -z "$pdf_path" ]; then
    echo "Error: No path entered."
    exit 1
fi

# Check if the file exists
if [ ! -f "$pdf_path" ]; then
    echo "Error: '$pdf_path' does not exist or is not a file."
    exit 1
fi

# Use pdf2john to extract the hash
pdf_hash=$(pdf2john "$pdf_path" 2>&1)

# Check if the hash extraction was successful
if [[ "$pdf_hash" == *"Could not find a PDF document"* ]]; then
    echo "Error: '$pdf_path' is not a valid PDF file."
    exit 1
elif [[ "$pdf_hash" == *"No password hash found"* ]]; then
    echo "Error: No password hash found in '$pdf_path'."
    exit 1
fi

echo "Extracted hash:"
echo "$pdf_hash"

# Create a temporary file to store the hash
tmp_file=$(mktemp)
echo "$pdf_hash" > "$tmp_file"

# Prompt user to select a wordlist
echo "Choose a wordlist option:"
echo "1. Use the default wordlist_1 (/usr/share/wordlists/john.lst)"
echo "3. Specify a custom wordlist"
read -p "Enter your choice (1 or 2 ): " choice

case $choice in
    1)
        wordlist_path="/usr/share/wordlists/john.lst"
        ;;
    2)
        echo "Enter the path to your custom wordlist:"
        read custom_wordlist_path
        # Check if the custom wordlist file exists
        if [ ! -f "$custom_wordlist_path" ]; then
            echo "Error: '$custom_wordlist_path' does not exist or is not a file."
            rm "$tmp_file"
            exit 1
        fi
        wordlist_path="$custom_wordlist_path"
        ;;
    *)
        echo "Error: Invalid choice."
        rm "$tmp_file"
        exit 1
        ;;
esac

# Attempt to crack the password using John the Ripper
echo "Attempting to crack the password using wordlist at '$wordlist_path'..."
john --format=pdf --pot=john.pot --fork=4 --wordlist="$wordlist_path" "$tmp_file"

# Clean up temporary file
rm "$tmp_file"

