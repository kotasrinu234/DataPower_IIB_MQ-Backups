#!/bin/bash

# Define variables
QMGR=$1
USER=$2
HOST=$3
date=`date '+%Y%m%d'`
BackupFile=/tmp/$QMGR"_"$date".cfg"
if [[ "$QMGR" == "PFMQP01" || "$QMGR" == "PFMQP02" ]]; then
    profile=".profile"
else
    profile=".bash_profile"
fi
touch /pfbackups/status_file_$date.txt
status_file="/pfbackups/status_file_$date.txt"

ssh $USER@$HOST "rm -f ${BackupFile}; . ./${profile};  dmpmqcfg -m $QMGR > ${BackupFile}"
if [ $? == 0 ]
then 
	scp $USER@$HOST:${BackupFile} /pfbackups/${QMGR}
	if [ $? == 0 ]
	then
		echo "${QMGR}: SUCCESS" >> "$status_file"
	else 
		echo "${QMGR}: FAILURE" >> "$status_file"
	fi
else
	echo "${QMGR}: FAILURE" >> "$status_file"
fi
ssh $USER@$HOST "rm -f ${BackupFile}"


