#!/bin/bash

# Prompt the user to enter the directory path
read -p "Enter the directory path: " dir_path

# Check if the directory exists
if [ ! -d "$dir_path" ]; then
  echo "Directory not found!"
  exit 1
fi

# Loop through all robot.txt or robots.txt files in the specified directory
for file in "$dir_path"/*robot.txt "$dir_path"/*robots.txt; do
  if [ -f "$file" ]; then
    # Generate the output file name based on the input file name
    output_file="${file%.txt}_disallowed.txt"
    
    echo "Processing $file"
    
    # Extract lines starting with "Disallow" and save to the output file with the prefix
    grep -i "^Disallow:" "$file" > "$output_file"
    
    echo "Disallowed links have been saved to $output_file."
  fi
done
