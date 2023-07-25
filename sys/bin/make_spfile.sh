SID=prdlpri1
if [ "$OS" == "Windows_NT" ]
then
  AdminRoot=f:\\oracle\\admin\\
else
  AdminRoot=/u02/app/oracle/admin/
fi

spfilepath=${AdminRoot}/${SID}/pfile/
spfilename=spfile${SID}.ora
pfilename=init${SID}.ora



sqlplus "/ as sysdba" <<++++
set echo on
create spfile='${spfilepath}${spfilename}' from pfile;
exit
++++

#
# Edit the pfile to reference the spfile
#
# First comment out any existing reference
sed s/spfile/#spfile/ <${spfilepath}${pfilename} >${spfilepath}${pfilename}

echo spfile=\'${spfilepath}${spfilename}\' >>${spfilepath}${pfilename}
