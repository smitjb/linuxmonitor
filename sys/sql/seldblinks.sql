column owner    heading "Owner"         format a15
column db_link  heading "DB Link"       format a40
column username heading "Username"      format a18
column host     heading "Host"          format a25
column created  heading "Created"       format a20

clear breaks
-- break on db_link skip 1

SELECT  db_link,
        owner,
        nvl(username, '--------') username,
        host,
        TO_CHAR(created, 'DD-Mon-YYYY HH24:MI:SS') created
FROM    dba_db_links
ORDER BY owner, db_link, host
/

clear breaks

