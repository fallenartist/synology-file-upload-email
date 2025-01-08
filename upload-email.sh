cd '/volume1/Assets/Uploads' || exit 
ls > current_dir 
current_dir_len=$(wc -l < current_dir) 
prior_dir_len=$(wc -l < prior_dir) 
num_new_items=$((current_dir_len - prior_dir_len)) 
if ! (diff current_dir prior_dir> /dev/null) && [ "$num_new_items" -gt 0 ] 
then /usr/bin/php -r "mail('alex@printhouse.co.uk','DataServer Upload Notification','Greetings Master, An additional $num_new_items new item-s have been uploaded to the Upload folder. Have a nice day! Synology');" 
fi 
cp current_dir prior_dir
