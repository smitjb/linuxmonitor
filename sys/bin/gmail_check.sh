
RECIPIENT=smitjb0809+monitor@gmail.com
SENDER=monitor@ponder-stibbons.com
UUID=${RANDOM}

TIMESTAMP=$( date "+%d/%m/%Y %H:%M")
echo "Gmail access check $TIMESTAMP ${UUID} " >>/jbs/sys/logs/gmail_check.log 
mail -s "Gmail access check $TIMESTAMP ${UUID} " -r ${SENDER} ${RECIPIENT}  <<EOT

This mail is intended to test if jim@ponder-stibbons.com can send emails to gmail
EOT


