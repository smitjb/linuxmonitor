select sid,serial# ,username,program,type, machine,terminal
from v$session where upper (username) like '%'
and upper(program) like '%'
and upper(terminal) like '%%'
and type <> 'BACKGROUND'
/
