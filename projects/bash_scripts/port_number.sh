#!/bin/bash

# Path to the services file
services_file="/etc/services"

# Function to search for the port number in the file
search_port_number() {
    local port_number="$1"

    if [ ! -f "$services_file" ]; then
        echo "File $services_file does not exist. Please check the path."
        exit 1
    fi

    # Search for the port number in the file
    result=$(grep -w "$port_number" "$services_file")

    if [ -n "$result" ]; then
        echo "Results found:"
        echo "$result"
    else
        echo "No information found for port number: $port_number"
    fi
}

# Prompt user for port number input
read -p "Enter the port number (e.g., 45002, 45514): " port_input

# Search for the port number
search_port_number "$port_input"
