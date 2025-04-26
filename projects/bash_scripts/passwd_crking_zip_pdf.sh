#!/bin/bash
# Bash script to crack the password of a PDF or ZIP file using pdf2john, zip2john, and John the Ripper

# Function to display usage information
usage() {
    echo "Usage: $0 [-t TYPE] [-f FILE_PATH] [-w WORDLIST]"
    echo "TYPE: 'pdf' or 'zip'"
    exit 1
}

# Parse command-line arguments
while getopts ":t:f:w:" opt; do
    case "${opt}" in
        t)
            file_type=${OPTARG}
            ;;
        f)
            file_path=${OPTARG}
            ;;
        w)
            wordlist=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

# Prompt user to enter the file type if not provided as an argument
if [ -z "$file_type" ]; then
    echo "Enter the type of file to crack (pdf or zip):"
    read file_type
fi

# Validate file type
if [ "$file_type" != "pdf" ] && [ "$file_type" != "zip" ]; then
    echo "Error: Invalid file type. Please enter 'pdf' or 'zip'."
    exit 1
fi

# Prompt user to enter the file path if not provided as an argument
if [ -z "$file_path" ]; then
    echo "Enter the path to the $file_type file:"
    read file_path
fi

# Check if entered path is empty
if [ -z "$file_path" ]; then
    echo "Error: No path entered."
    exit 1
fi

# Check if the file exists
if [ ! -f "$file_path" ]; then
    echo "Error: '$file_path' does not exist or is not a file."
    exit 1
fi

# Prompt user to enter the wordlist location if not provided as an argument
if [ -z "$wordlist" ]; then
    echo "Enter the path to the wordlist (press Enter to use the default '/home/parrot/wordlist1.txt'):"
    read wordlist
    # Use default wordlist if user does not provide one
    if [ -z "$wordlist" ]; then
        wordlist="/home/parrot/wordlist1.txt"
    fi
fi

# Check if wordlist file exists
if [ ! -f "$wordlist" ]; then
    echo "Error: Wordlist '$wordlist' does not exist or is not a file."
    exit 1
fi

# Extract the hash using the appropriate tool
if [ "$file_type" == "pdf" ]; then
    hash_output=$(pdf2john "$file_path" 2>&1)
elif [ "$file_type" == "zip" ]; then
    hash_output=$(zip2john "$file_path" 2>&1)
fi

# Check if the hash extraction was successful
if [[ "$hash_output" == *"Could not find a PDF document"* ]] || [[ "$hash_output" == *"No password hash found"* ]]; then
    echo "Error: '$file_path' is not a valid $file_type file or does not contain a password hash."
    exit 1
fi

echo "Extracted hash:"
echo "$hash_output"

# Create a temporary file to store the hash
tmp_file=$(mktemp)
echo "$hash_output" > "$tmp_file"

# Attempt to crack the password using John the Ripper
echo "Attempting to crack the password..."
if [ "$file_type" == "pdf" ]; then
    john --format=pdf --pot=john.pot --fork=4 --wordlist="$wordlist" "$tmp_file"
elif [ "$file_type" == "zip" ]; then
    john --format=zip --pot=john.pot --fork=4 --wordlist="$wordlist" "$tmp_file"
fi

# Clean up temporary file
rm "$tmp_file"
