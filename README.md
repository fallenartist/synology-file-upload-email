# Synology file upload email notification
Synology NAS custom script for Task Scheduler to send emails when there are new uploads to a folder via a file request.

1. Select a folder on shared drive, then File Station -> Actions -> Create file request
2. Control Panel -> Task Scheduler -> Create Scheduled Task -> User-defined script
3. General -> give the task a name and select user, e.g. root
4. Task Settings -> enable "Send run details by email"
5. Paste script into "Run command" field. Update upload folder path and recipient email(s). You can remove #comments.

Tested on DSM 7.2
