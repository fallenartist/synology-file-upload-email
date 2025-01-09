#!/bin/bash

cd '/volume1/Assets/Uploads' || exit

# Check if prior_dir exists, create it if missing
if [ ! -f prior_dir.txt ]; then
    touch prior_dir.txt
fi

# Generate a list of current directory structure including files
find . -type f > current_dir.txt

# Find added items
added_items=$(comm -13 prior_dir.txt current_dir.txt)

# Prepare email body if there are new files
if [ -n "$added_items" ]; then
    num_new_items=$(echo "$added_items" | wc -l)
    email_body=$(printf "Greetings Master,\n\nAn additional $num_new_items new item(s) have been uploaded:\n\n$added_items\n\nHave a nice day!\nSynology")

    # Send email notification to multiple recipients
    /usr/bin/php -r "
    mail('user1@example.com', 'Server Upload Notification', '$email_body', 'From: admin@example.com');
    mail('user2@example.com', 'Server Upload Notification', '$email_body', 'From: admin@example.com');
    mail('user3@example.com', 'Server Upload Notification', '$email_body', 'From: admin@example.com');
    "
fi

# Update prior directory snapshot
cp current_dir.txt prior_dir.txt
