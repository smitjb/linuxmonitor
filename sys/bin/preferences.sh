#! /bin/sh

# OS specific support.  $var _must_ be set to either true or false.
cygwin=false;
darwin=false;
case "`uname`" in
  CYGWIN*) cygwin=true ;;
  Darwin*) darwin=true ;;
esac

if [ -z "$JAVACMD" ] ; then 
  if [ -n "$JAVA_HOME"  ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then 
      # IBM's JDK on AIX uses strange locations for the executables
      JAVACMD=$JAVA_HOME/jre/sh/java
    else
      JAVACMD=$JAVA_HOME/bin/java
    fi
  else
    JAVACMD=java
  fi
fi
 
if [ ! -x "$JAVACMD" ] ; then
  echo "Error: JAVA_HOME is not defined correctly."
  echo "  We cannot execute $JAVACMD"
  exit
fi

if [ -n "$CLASSPATH" ] ; then
  if $cygwin; then
	 CLASSPATH=`cygpath --path --unix "$CLASSPATH"`
  fi
  LOCALCLASSPATH=$CLASSPATH
fi

# add in the dependency .jar files
DIRLIBS=*.jar
for i in ${DIRLIBS}
do
  if [ -z "$LOCALCLASSPATH" ] ; then
    LOCALCLASSPATH=$i
  else
    LOCALCLASSPATH="$i":$LOCALCLASSPATH
  fi
done

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
  JAVA_HOME=`cygpath --path --windows "$JAVA_HOME"`
  LOCALCLASSPATH=`cygpath --path --windows "$LOCALCLASSPATH"`
fi

$JAVACMD -classpath "$LOCALCLASSPATH" de.hunsicker.jalopy.ui.PreferencesDialog
