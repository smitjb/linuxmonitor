accept recon_ueh_password

accept recon_seq_password


set verify off


spool physops_recon_users_oracle.log

CREATE USER physops_recon_ueh
    IDENTIFIED BY &&recon_ueh_password DEFAULT TABLESPACE IL_IST_GOIL_UEH_DATA 
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED 
    ON IL_IST_GOIL_UEH_DATA
    ACCOUNT UNLOCK;
GRANT DB_SESSION   TO physops_recon_ueh;
GRANT DB_USER      TO physops_recon_ueh;


CREATE USER physops_recon_seq
    IDENTIFIED BY &&recon_seq_password DEFAULT TABLESPACE IL_IST_GOIL_SEQ_DATA 
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED 
    ON IL_IST_GOIL_SEQ_DATA
    ACCOUNT UNLOCK;
GRANT DB_SESSION   TO physops_recon_seq;
GRANT DB_USER      TO physops_recon_seq;


spool off


