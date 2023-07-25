select 'DATABASE LINK ',
       substr(DB_LINK,1,30) db_link,
       substr(USERNAME,1,15) username,
       substr(HOST,1,20) host,
       CREATED
from   user_db_links;

