#!/bin/bash

# Function to create a user with a predefined password
create_user() {
    local username=$1
    local password="admin@123"
    
    # Check if the user already exists
    if id "$username" &>/dev/null; then
        echo "Error: User $username already exists. Please choose a different username."
        return 1
    fi
    
    sudo useradd -m "$username"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create user $username."
        return 1
    fi

    echo "$username:$password" | sudo chpasswd
    if [ $? -ne 0 ]; then
        echo "Error: Failed to set password for $username."
        sudo userdel "$username"
        return 1
    fi

    echo "User $username created with password $password"
    return 0
}

# Function to create groups if they don't exist
create_group_if_not_exists() {
    local group="$1"
    if ! getent group "$group" > /dev/null 2>&1; then
        sudo groupadd "$group"
        echo "Group '$group' created."
    else
        echo "Group '$group' already exists."
    fi
}

# Function to add a user to a group
add_user_to_group() {
    local user="$1"
    local group="$2"
    sudo usermod -aG "$group" "$user"
    echo "User '$user' added to group '$group'."
}

# Groups for different roles
ADMIN_GROUP="admin"
BACKEND_GROUP="backend"
FRONTEND_GROUP="frontend"

# Create groups if they don't exist
create_group_if_not_exists "$ADMIN_GROUP"
create_group_if_not_exists "$BACKEND_GROUP"
create_group_if_not_exists "$FRONTEND_GROUP"

# Set up sudo privileges for admin group
sudoers_file="/etc/sudoers.d/$ADMIN_GROUP"
if [ ! -f "$sudoers_file" ]; then
    echo "%$ADMIN_GROUP ALL=(ALL) ALL" | sudo tee "$sudoers_file"
    sudo chmod 0440 "$sudoers_file"
    echo "Sudo privileges granted to the '$ADMIN_GROUP' group."
else
    echo "Sudo privileges for the '$ADMIN_GROUP' group already configured."
fi

# Ask for the number of users to create
read -p "How many users would you like to create? " user_count

# Loop through the number of users and prompt for each username and role
for (( i=1; i<=user_count; i++ ))
do
    while true; do
        read -p "Enter username for user $i: " username
        create_user "$username" && break
    done

    while true; do
        read -p "Enter role for user $i (admin/backend/frontend): " role
        case "$role" in
            admin)
                add_user_to_group "$username" "$ADMIN_GROUP"
                ;;
            backend)
                add_user_to_group "$username" "$BACKEND_GROUP"
                ;;
            frontend)
                add_user_to_group "$username" "$FRONTEND_GROUP"
                ;;
            *)
                echo "Invalid role. Please enter 'admin', 'backend', or 'frontend'."
                continue
                ;;
        esac
        break
    done

    # Verification of group assignment
    echo "Verifying group membership for $username..."
    groups "$username"

    # Verification of sudo privileges for admin users
    if [ "$role" == "admin" ]; then
        echo "Verifying sudo privileges for $username..."
        sudo -i -u "$username" sudo -l | grep "ALL=(ALL) ALL"
    fi
done

echo "All users have been created and assigned roles."

