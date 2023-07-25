alter system switch logfile;

/u06/oradata/dmglng8/dmglng8_redo_t1_g1_m1.rdo
/u07/oradata/dmglng8/dmglng8_redo_t1_g1_m2.rdo
/u06/oradata/dmglng8/dmglng8_redo_t1_g2_m1.rdo
/u07/oradata/dmglng8/dmglng8_redo_t1_g2_m2.rdo
/u06/oradata/dmglng8/dmglng8_redo_t1_g3_m1.rdo
/u07/oradata/dmglng8/dmglng8_redo_t1_g3_m2.rdo
/u06/oradata/dmglng8/dmglng8_redo_t1_g4_m1.rdo
/u07/oradata/dmglng8/dmglng8_redo_t1_g4_m2.rdo
/u06/oradata/dmglng8/dmglng8_redo_t1_g5_m1.rdo
/u07/oradata/dmglng8/dmglng8_redo_t1_g5_m2.rdo


alter database add logfile
  GROUP 1 ('/u06/oradata/dmglng8/dmglng8_redo_t1_g1_m1.rdo'
          ,'/u07/oradata/dmglng8/dmglng8_redo_t1_g1_m2.rdo') SIZE 201m;

alter database add logfile
  GROUP 2 ('/u06/oradata/dmglng8/dmglng8_redo_t1_g2_m1.rdo'
          ,'/u07/oradata/dmglng8/dmglng8_redo_t1_g2_m2.rdo') SIZE 201m;

alter database add logfile
  GROUP 3 ('/u06/oradata/dmglng8/dmglng8_redo_t1_g3_m1.rdo'
          ,'/u07/oradata/dmglng8/dmglng8_redo_t1_g3_m2.rdo') SIZE 201m;

alter database add logfile
  GROUP 4 ('/u06/oradata/dmglng8/dmglng8_redo_t1_g4_m1.rdo'
          ,'/u07/oradata/dmglng8/dmglng8_redo_t1_g4_m2.rdo') SIZE 201m;

alter database add logfile
  GROUP 5 ('/u06/oradata/dmglng8/dmglng8_redo_t1_g5_m1.rdo'
          ,'/u07/oradata/dmglng8/dmglng8_redo_t1_g5_m2.rdo') SIZE 201m;

alter database add logfile GROUP 6 ('/u06/oradata/dmglng8/dmglng8_redo_t1_g6_m1.rdo') SIZE 201m;
alter database add logfile GROUP 7 ('/u06/oradata/dmglng8/dmglng8_redo_t1_g7_m1.rdo') SIZE 201m;

alter database drop logfile member '/u07/oradata/dmglng8/dmglng8_redo_t1_g1_m2.rdo';
alter database drop logfile member '/u07/oradata/dmglng8/dmglng8_redo_t1_g2_m2.rdo';
alter database drop logfile member '/u07/oradata/dmglng8/dmglng8_redo_t1_g3_m2.rdo';
alter database drop logfile member '/u07/oradata/dmglng8/dmglng8_redo_t1_g4_m2.rdo';
alter database drop logfile member '/u07/oradata/dmglng8/dmglng8_redo_t1_g5_m2.rdo';

alter database add  logfile member '/u07/oradata/dmglng8/dmglng8_redo_t1_g1_m2.rdo' REUSE to GROUP 1;
alter database add  logfile member '/u07/oradata/dmglng8/dmglng8_redo_t1_g2_m2.rdo' REUSE to GROUP 2;
alter database add  logfile member '/u07/oradata/dmglng8/dmglng8_redo_t1_g3_m2.rdo' REUSE to GROUP 3;
alter database add  logfile member '/u07/oradata/dmglng8/dmglng8_redo_t1_g4_m2.rdo' REUSE to GROUP 4;
alter database add  logfile member '/u07/oradata/dmglng8/dmglng8_redo_t1_g5_m2.rdo' REUSE to GROUP 5;

alter database add  logfile member '/opt/app/oracle/admin/dmglng8/redo/dmglng8_redo_t1_g1_m2.rdo' REUSE to GROUP 1;
alter database add  logfile member '/opt/app/oracle/admin/dmglng8/redo/dmglng8_redo_t1_g2_m2.rdo' REUSE to GROUP 2;
alter database add  logfile member '/opt/app/oracle/admin/dmglng8/redo/dmglng8_redo_t1_g3_m2.rdo' REUSE to GROUP 3;
alter database add  logfile member '/opt/app/oracle/admin/dmglng8/redo/dmglng8_redo_t1_g4_m2.rdo' REUSE to GROUP 4;
alter database add  logfile member '/opt/app/oracle/admin/dmglng8/redo/dmglng8_redo_t1_g5_m2.rdo' REUSE to GROUP 5;

alter database drop logfile GROUP 1;
alter database drop logfile GROUP 2;
alter database drop logfile GROUP 3;
alter database drop logfile GROUP 4;
alter database drop logfile GROUP 5;
alter database drop logfile GROUP 6;
alter database drop logfile GROUP 7;


!rm /u06/oradata/dmglng8/dmglng8_redo_t1_g1_m1.rdo
!rm /u06/oradata/dmglng8/dmglng8_redo_t1_g2_m1.rdo
!rm /u06/oradata/dmglng8/dmglng8_redo_t1_g3_m1.rdo
!rm /u06/oradata/dmglng8/dmglng8_redo_t1_g4_m1.rdo
!rm /u06/oradata/dmglng8/dmglng8_redo_t1_g5_m1.rdo

!rm /u07/oradata/dmglng8/dmglng8_redo_t1_g1_m2.rdo
!rm /u07/oradata/dmglng8/dmglng8_redo_t1_g2_m2.rdo
!rm /u07/oradata/dmglng8/dmglng8_redo_t1_g3_m2.rdo
!rm /u07/oradata/dmglng8/dmglng8_redo_t1_g4_m2.rdo
!rm /u07/oradata/dmglng8/dmglng8_redo_t1_g5_m2.rdo

!rm  /u06/oradata/dmglng8/dmglng8_redo_t1_g6_m1.rdo
!rm  /u07/oradata/dmglng8/dmglng8_redo_t1_g6_m2.rdo
!rm  /u06/oradata/dmglng8/dmglng8_redo_t1_g7_m1.rdo
!rm  /u07/oradata/dmglng8/dmglng8_redo_t1_g7_m2.rdo


alter system switch logfile;
