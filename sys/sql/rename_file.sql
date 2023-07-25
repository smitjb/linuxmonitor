prompt "Ensure the database is not mounted"
host mv '&1' '&2'
startup mount
alter database rename file '&1' to '&2';
shutdown
