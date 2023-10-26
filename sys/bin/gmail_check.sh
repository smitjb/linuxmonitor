
RECIPIENT=smitjb0809+monitor@gmail.com
SENDER=monitor@ponder-stibbons.com

TIMESTAMP=$( date "+%d/%m/%Y %H:%M")
mail -s "Gmail access check $TIMESTAMP" -r ${SENDER} ${RECIPIENT}  <<EOT

This mail is intended to test if jim@ponder-stibbons.com can send emails to gmail
EOT


