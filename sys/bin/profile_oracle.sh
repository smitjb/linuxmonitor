ORACLE_BASE="/u01/app/oracle"
ORACLE_HOME="$ORACLE_BASE/product/10.1.0/Db_1"
export ORACLE_SID=test1
PATH="$ORACLE_HOME/bin:$PATH"
if [ -d $ORACLE_HOME/OPatch ]; then
	PATH="$ORACLE_HOME/OPatch:$PATH"
fi
export PATH
EDITOR="vim"
export EDITOR
PS1="(\$ORACLE_SID)[\u@\h \W]$ "
export PS1

alias vi=vim
alias pico=nano
alias alert="vi + \$ORACLE_BASE/admin/\$ORACLE_SID/bdump/alert_\$ORACLE_SID.log"
alias rm="rm -i"
alias oraarch="cd /u02/oradata/\$ORACLE_SID/archive"
alias bdump="cd \$ORACLE_HOME/admin/\$ORACLE_SID/bdump/"
alias udump="cd \$ORACLE_HOME/admin/\$ORACLE_SID/udump/"
alias cdump="cd \$ORACLE_HOME/admin/\$ORACLE_SID/cdump/"
alias sid="echo \${ORACLE_SID:-not defined}"
alias oraps="pstree -G |egrep \"oracle|tnsl|sqlplus\""
if [ ` which rlwrap >/dev/null 2>&1` ]; then
	alias rsqlplus="rlwrap sqlplus"
	alias rrman="rlwrap rman"
fi
