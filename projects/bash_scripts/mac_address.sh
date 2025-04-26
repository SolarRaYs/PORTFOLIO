#!/bin/bash

# Path to the MAC address information file
mac_file="/usr/share/wireshark/manuf"

# Normalize the input MAC address (e.g., fe:f0:5e -> FE:F0:5E)
normalize_mac() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Function to search for the MAC address in the file
search_mac_address() {
    local mac_address="$1"
    normalized_mac=$(normalize_mac "$mac_address")

    if [ ! -f "$mac_file" ]; then
        echo "File $mac_file does not exist. Please check the path."
        exit 1
    fi

    # Search for the MAC address in the file, match on the first part
    result=$(grep -i "^$normalized_mac" "$mac_file")

    if [ -n "$result" ]; then
        echo "Results found:"
        echo "$result"
    else
        echo "No information found for MAC address: $mac_address"
    fi
}

# Prompt user for MAC address input
read -p "Enter the MAC address (e.g., FC:FF:AA or fc:ff:aa): " mac_input

# Search for the MAC address
search_mac_address "$mac_input"

