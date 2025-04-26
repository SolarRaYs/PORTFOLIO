#!/bin/bash

# Hardcoded file path
file="/home/parrot/Desktop/abbreviations.txt"

# Check if the file exists
if [ ! -f "$file" ]; then
    echo "File not found!"
    exit 1
fi

# Prompt for abbreviation
read -p "Enter the abbreviation: " input_abbreviation

# Convert input abbreviation to uppercase
input_abbreviation=$(echo "$input_abbreviation" | tr '[:lower:]' '[:upper:]')

# Initialize a flag to check if abbreviation was found
found=0

# Read the file line by line
while IFS= read -r line; do
    # Extract abbreviation and description using awk
    abbr=$(echo "$line" | awk '{print $1}')
    description=$(echo "$line" | awk '{$1=""; print substr($0,2)}')

    # Convert abbreviation from file to uppercase for comparison
    abbr=$(echo "$abbr" | tr '[:lower:]' '[:upper:]')

    # Check if the abbreviation matches
    if [ "$abbr" == "$input_abbreviation" ]; then
        echo "Description for \"$input_abbreviation\" is: $description"
        found=1
        break
    fi
done < "$file"

# If no match was found
if [ $found -eq 0 ]; then
    echo "No description found for \"$input_abbreviation\""
fi

exit 0

