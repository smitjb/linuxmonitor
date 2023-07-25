ttitle 'Asm groups'
SELECT GROUP_NUMBER grpno,
  NAME,
  STATE,
  TYPE,
 TOTAL_MB,
  FREE_MB,
  round((free_mb/total_mb)*100,0) pct_Free,
  HOT_USED_MB,
  COLD_USED_MB,
  REQUIRED_MIRROR_FREE_MB req_mir_free,
  USABLE_FILE_MB,
  SECTOR_SIZE,
  BLOCK_SIZE
FROM V$ASM_DISKGROUP;
ttitle off