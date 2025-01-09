# Synology file upload email notification
Synology NAS custom script for Task Scheduler to send emails when there are new uploads to a folder via a file request.

1. Create a folder for uploads.
2. Select the folder, then File Station -> Actions -> Create file request
3. Control Panel -> Task Scheduler -> Create Scheduled Task -> User-defined script
4. General -> give the task a name and select user, e.g. root
5. Task Settings -> enable "Send run details by email"
6. Paste script into "Run command" field. Update upload folder path and recipient email(s). You can remove #comments.

The advanced script uses two separate file upload requests created by two distinct users and then emails both lists to separate email addresses.

Tested on DSM 7.2
