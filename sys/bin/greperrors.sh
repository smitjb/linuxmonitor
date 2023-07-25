grep -c SMTP *.log | sed 's/\([0-9][0-9]\)\([0-9][0-9]\)\(200[456]\)\./\3\2\1./'|sort >smtperrors.txt
grep -c "Unable to send" *.log | sed 's/\([0-9][0-9]\)\([0-9][0-9]\)\(200[456]\)\./\3\2\1./'|sort >mailerrors.txt
