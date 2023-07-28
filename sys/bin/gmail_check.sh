
TIMESTAMP=$( date "+%d/%m/%Y %H:%M")
mail -s "Gmail access check $TIMESTAMP" -r monitor@ponder-stibbons.com smitjb0809@gmail.com  <<EOT

This mail is intended to test if jim@ponder-stibbons.com can send emails to gmail
EOT


