#!/bin/bash

# Prompt the user to enter the directory path
read -p "Enter the directory path: " directory

# Check if the directory exists
if [ ! -d "$directory" ]; then
    echo "The directory does not exist."
    exit 1
fi

output_file="email_id"

# Empty the output file if it exists
> "$output_file"

# Find all files and search for email addresses
find "$directory" -type f | while read -r file; do
    # Extract email addresses from the file
    email=$(grep -Eo "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}" "$file")
    
    # If an email is found, save it to the output file
    if [ -n "$email" ]; then
        echo "$(basename "$file") : $email" >> "$output_file"
    fi
done

echo "Email IDs have been saved to $output_file."
