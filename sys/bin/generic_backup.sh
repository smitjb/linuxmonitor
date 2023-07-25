#!/bin/bash
#
# Params
#  Source directory
#  Target directory
# OR
#  Target device
#  gzip or not.
#  label

do_compressed_backup() {
    
 cd ${SOURCEDIR}
 tar cvf - *| gzip > ${TARGET}/${LABEL}.tar
    
}

do_backup() {
    
 cd ${SOURCEDIR}
 tar cvf ${TARGET}/${LABEL}.tar
 
}

set -x
SOURCEDIR=""
DESTDIR=""
DESTDEVICE=""
USEGZIP=N
LABEL=""

OPTARGS=$(getopt -o zs:d:v:l: --long zip,source:,directory:,device:,label: \
               -n 'generic_backup.sh'\
               -- ${*})

eval set -- "${OPTARGS}"
while true ; do
        case "$1" in
                -s|--source) SOURCEDIR="$2"; 
                                     shift 2 ;;
                -z|--zip) USEGIP=Y
                                   shift  ;;
                -l|--label)
                                LABEL=${2}
                                shift 2 ;; 
                -d|--directory)
                                DESTDIR="${2}"
                                shift 2 ;;
                -v|--device)
                                DESTDEVICE="${2}"
                                shift 2 ;;
                --) shift
                   break  ;;
        esac
done

if [ -z ${SOURCEDIR} ];then
        echo "You must provide a source directory"
        exit 1
fi

if [ -z ${DESTDIR} -a -z ${DESTDEVICE} ];then
        echo "You must provide either a destination directory of device"
        exit 1
fi

if [ -z "LABEL"];then
    LABEL=backup
fi


TSTAMP=$(date +%Y%m%d%H%M%S)
LABEL=${LABEL}_${TSTAMP}

  if [ ! -d ${SOURCEDIR} ];then
        echo "Source directory (${SOURCEDIR}) does not exist"
        exit 1
    fi

if [ -z  ${DESTDEVICE} ];then
    TARGET=${DESTDIR}
    if [ ! -d ${DESTDIR} ];then
        echo "Destination directory (${DESTDIR}) does not exist"
        exit 1
    fi
else
    if [ ! -d ${DESTDEVICE}/BACKUP ];then
        echo "Destination device (${DESTDEVICE}) does not exist or is not backup device"
        exit 1
    else
        TARGET=${DESTDEVICE}/BACKUP
    fi
fi
        
