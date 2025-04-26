#!/bin/bash

# Prompt user for the username to be removed
read -p "Enter the username to be removed: " username

# Check if the user exists
if id "$username" &>/dev/null; then
    # Remove the user from the system
    sudo deluser --remove-home "$username"
    if [ $? -eq 0 ]; then
        echo "User '$username' has been removed along with their home directory."
    else
        echo "Failed to remove user '$username'."
    fi
else
    echo "User '$username' does not exist."
fi
