#!/bin/bash

# In order for the script to distinguish between regional uploads
# create separate users named 'UK Branch' and 'US Branch' with priviledges
# to the upload folder, log in to Synology with each one and create
# file upload request. Upload folder will then contain these usernames
# for the script to pick up.

# Navigate to the target directory
cd '/volume1/Assets/Uploads' || exit 

# Check if prior_dir.txt exists, create it if missing
if [ ! -f prior_dir.txt ]; then
    touch prior_dir.txt  # Create an empty prior_dir.txt file
fi

# Generate a sorted list of current directory structure excluding specific files
find . -type f ! -name "prior_dir.txt" ! -name "current_dir.txt" | sort > current_dir.txt 

# Find added items
added_items=$(comm -13 prior_dir.txt current_dir.txt)

# Process new items if there are any
if [ -n "$added_items" ]; then
    # Variables to hold categorized file lists and unique folder tracking
    uk_list=""
    us_list=""
    general_list=""
    unique_folders=() # For all unique folder names
    num_new_files=0

    # Categorize files by folder name
    while IFS= read -r line; do
        folder_name=$(dirname "$line" | cut -d '/' -f 2) # Extract the immediate folder name
        num_new_files=$((num_new_files + 1)) # Increment the file count

        # Add folder name to the global unique folder list
        unique_folders+=("$folder_name")

        # Categorize by folder pattern
        if [[ "$folder_name" == *"UK Branch"* ]]; then
            uk_list+="$line\n"
        elif [[ "$folder_name" == *"US Branch"* ]]; then
            us_list+="$line\n"
        else
            general_list+="$line\n"
        fi
    done <<< "$added_items"

    # Count unique folders for all files
    total_unique_folders=$(printf "%s\n" "${unique_folders[@]}" | sort -u | wc -l)

    # Prepare email bodies
    email_body_all=$(printf "Greetings,\n\n%d new files from %d clients have been uploaded to the server:\n\n%s\n\nBest regards,\nSynology" "$num_new_files" "$total_unique_folders" "$added_items")
    
    if [ -n "$uk_list" ]; then
        num_uk_files=$(echo -e "$uk_list" | wc -l)
        num_uk_folders=$(printf "%s\n" "${unique_folders[@]}" | grep "UK Branch" | sort -u | wc -l)
        email_body_uk=$(printf "Greetings,\n\n%d new files from %d clients have been uploaded to the server:\n\n%s\n\nBest regards,\nSynology" "$num_uk_files" "$num_uk_folders" "$uk_list")
    fi

    if [ -n "$us_list" ]; then
        num_us_files=$(echo -e "$us_list" | wc -l)
        num_us_folders=$(printf "%s\n" "${unique_folders[@]}" | grep "US Branch" | sort -u | wc -l)
        email_body_us=$(printf "Greetings,\n\n%d new files from %d clients have been uploaded to the server:\n\n%s\n\nBest regards,\nSynology" "$num_us_files" "$num_us_folders" "$us_list")
    fi

    # Send general notification to primary recipients
    /usr/bin/php -r "
    mail('user1@example.com', 'Server Upload Notification', '$email_body_all', 'From: admin@example.com');
    mail('user2@example.com', 'Server Upload Notification', '$email_body_all', 'From: admin@example.com');
    "

    # Send UK-specific list
    if [ -n "$uk_list" ]; then
        /usr/bin/php -r "
        mail('uk@example.com', 'UK Branch Upload Notification', '$email_body_uk', 'From: admin@example.com');
        "
    fi

    # Send US-specific list
    if [ -n "$us_list" ]; then
        /usr/bin/php -r "
        mail('us@example.com', 'US Branch Upload Notification', '$email_body_us', 'From: admin@example.com');
        "
    fi
fi

# Update prior directory snapshot
cp current_dir.txt prior_dir.txt
