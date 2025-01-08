#!/bin/bash

cd '/volume1/Assets/Uploads' || exit 

# Generate a list of current directory structure including files
find . -type f > current_dir 

# Find added items
added_items=$(comm -13 prior_dir current_dir)

# Prepare email body if there are new files
if [ -n "$added_items" ]; then
    num_new_items=$(echo "$added_items" | wc -l)
    email_body="Greetings Master,\n\nAn additional $num_new_items new item(s) have been uploaded:\n\n$added_items\n\nHave a nice day!\nSynology"

    # Send email notification to multiple recipients
    /usr/bin/php -r "
    mail('user1@example.com', 'Server Upload Notification', '$email_body');
    mail('user2@example.com', 'Server Upload Notification', '$email_body');
    mail('user3@example.com', 'Server Upload Notification', '$email_body');
    "
fi

# Update prior directory snapshot
cp current_dir prior_dir
